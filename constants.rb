CONTINUE = false

LIST_URL = 'https://optgeo.github.io/jp-tile-list/list.csv'
SRC_BASE_URL = 'https://cyberjapandata.gsi.go.jp/xyz/experimental_bvmap'

Z_LOT = 6
Z_SRC = 9
MINZOOM = 10
MAXZOOM = 18

TMP_DIR = '/mnt/ramdisk'
FIFO_DIR = 'fifo'
LOT_DIR = 'lot'
DST_DIR = 'dst'
MERGED_DIR = 'merged'

VT2GEOJSON_PATH = '../vt2geojson/cmd/vt2geojson/vt2geojson'
LAYERS = { # 12..14 data are based on small samples and so not conclusive.
  6 => %w{boundary coastline elevation label railway searoute symbol},
  7 => %w{boundary coastline elevation label railway road searoute symbol},
  8 => %w{boundary coastline elevation label railway road searoute symbol},
  9 => %w{boundary contour label landforma river road searoute symbol waterarea},
  10 => %w{boundary contour label landforma railway river road searoute transp waterarea wstructurea},
  11 => %w{boundary contour label landforma railway river road searoute symbol transp waterarea wstructurea},
  12 => %w{boundary contour label landforma railway river road searoute symbol transp waterarea wstructurea},
  13 => %w{boundary building contour label landforma other railway river road searoute symbol waterarea},
  14 => %w{boundary building coastline contour label landforml river road searoute structurel symbol waterarea},
  15 => %w{boundary building coastline contour elevation label landforma landforml landformp railway river road searoute structurea structurel symbol transp waterarea wstructurea}
}
def tgc
  Time.now.to_i / 1800
end

