#!/bin/sh
set -e

rm -rf build
mkdir -p build/usr/share
git clone https://github.com/elasticsearch/kibana.git build/usr/share/kibana3
rm -rf build/usr/share/kibana3/.git*

PKG_VERSION=$(
  grep -i version build/usr/share/kibana3/package.json \
    | cut -d '"' -f4
)

if [ ! -f kibana3_${PKG_VERSION}_all.deb ]
then

  echo "#!/bin/sh" > build/post-install
  echo "chown -R www-data:www-data /usr/share/kibana3" >> build/post-install

  fpm -s dir -t deb \
    --architecture all \
    -n kibana3 \
    -v ${PKG_VERSION} \
    --prefix / \
    --after-install build/post-install \
    -C build usr

  rm -rf build
fi

