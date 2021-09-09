require './constants'

desc 'produce tiles'
task :tiles do
  system "rm #{DST_DIR}/*.mbtiles" unless CONTINUE 
  sh <<-EOS
rm #{FIFO_DIR}/*; rm #{LOT_DIR}/*; \
curl #{LIST_URL} | grep ^#{Z_LOT}, | shuf | \
parallel --jobs=1 --line-buffer \
ruby produce_lot.rb {}; 
tile-join -o #{MERGED_DIR}/#{Z_SRC}.mbtiles #{LOT_DIR}/*.mbtiles
  EOS
end
