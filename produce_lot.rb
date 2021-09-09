require './constants'

LOT_ZXY = ARGV[0].split(',').map {|v| v.to_i}

def process(zxy)
  print "process #{zxy} in #{LOT_ZXY}\n"
  tile_path = "#{TMP_DIR}/#{zxy.join('-')}.pbf"
  status = `curl #{SRC_BASE_URL}/#{zxy.join('/')}.pbf -o #{tile_path} -w '%{http_code}' -s`
  if status == '200'
    LAYERS[Z_SRC].each {|layer|
      fifo_path = "#{FIFO_DIR}/#{LOT_ZXY.join('-')}-#{layer}"
      system <<-EOS
#{VT2GEOJSON_PATH} -gzipped=false -mvt #{tile_path} -layer #{layer} \
-z #{zxy[0]} -x #{zxy[1]} -y #{zxy[2]} \
| tippecanoe-json-tool > #{fifo_path}
      EOS
    }
  end
  system "rm #{tile_path}"
end

def jump_into(zxy)
  if zxy[0] == Z_SRC
    process(zxy)
  else
    2.times {|i|
      2.times {|j|
        jump_into([
          zxy[0] + 1,
          2 * zxy[1] + i,
          2 * zxy[2] + j
        ])
      }
    }
  end
end

def charge
  hooks = Hash.new
  LAYERS[Z_SRC].each {|layer|
    fifo_path = "#{FIFO_DIR}/#{LOT_ZXY.join('-')}-#{layer}"
    mbtiles_path = "#{LOT_DIR}/#{LOT_ZXY.join('-')}-#{layer}.mbtiles"
    system "rm #{fifo_path}" if File.exist?(fifo_path)
    system "mkfifo #{fifo_path}"
    hooks[layer] = {
      :fifo => File.open(fifo_path, 'w+'),
      :pid => spawn(
        <<-EOS
tippecanoe --force --layer=#{layer} -o #{mbtiles_path} \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} \
--detect-shared-borders --coalesce --hilbert \
< #{fifo_path} 2>&1
        EOS
      )
    }
  }
  hooks
end

def withdraw(hooks)
  LAYERS[Z_SRC].each {|layer|
    fifo_path = "#{FIFO_DIR}/#{LOT_ZXY.join('-')}-#{layer}"
    print "Producing vector tiles for #{fifo_path} (pid #{hooks[layer][:pid]})...\n"
    $stdout.flush
    hooks[layer][:fifo].flush
    hooks[layer][:fifo].close
    Process.waitpid(hooks[layer][:pid])
    system "rm #{fifo_path}"
    print "done (#{fifo_path}, pid #{hooks[layer][:pid]}).\n"
  }
end

dst_path = "#{DST_DIR}/#{LOT_ZXY.join('-')}.mbtiles"
if File.exist?(dst_path)
else
  hooks = charge
  jump_into(LOT_ZXY)
  withdraw(hooks)

  system <<-EOS
tile-join -o #{dst_path} \
#{LOT_DIR}/#{LOT_ZXY.join('-')}*.mbtiles
  EOS
end

