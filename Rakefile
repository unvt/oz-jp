require './constants'

desc 'produce tiles'
task :tiles do
  sh <<-EOS
rm #{FIFO_DIR}/*; rm #{LOT_DIR}/*; \
curl #{LIST_URL} | grep ^#{Z_LOT}, | shuf | head -n 50 | \
parallel --jobs=1 --line-buffer \
ruby produce_lot.rb {}
  EOS
end
