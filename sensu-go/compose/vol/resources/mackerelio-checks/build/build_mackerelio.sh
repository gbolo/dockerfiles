set -e

ARTIFACT_DIR="${1:-./artifacts}"
if [ ! -d ${ARTIFACT_DIR} ]; then
  echo "artifacts directory does not exist: $ARTIFACT_DIR"
  echo "creating it..."
  mkdir $ARTIFACT_DIR
fi

mackerelio_version="${2:-master}"
echo "mackerelio_version is set to: ${mackerelio_version}"

if ! command -v git &> /dev/null; then
    echo "git is not installed. Attempting to use wget"
    wget https://github.com/mackerelio/go-check-plugins/archive/${mackerelio_version}.tar.gz
    tar -xzvf ${mackerelio_version}.tar.gz
    mv go-check-plugins-${mackerelio_version} go-check-plugins
    cd go-check-plugins
else
  git clone https://github.com/mackerelio/go-check-plugins.git
  cd go-check-plugins
  if [ "${mackerelio_version}" != "master" ]; then
    git checkout ${mackerelio_version}
  fi
fi

if ! command -v make &> /dev/null; then
  # alpine image doesnt come with make installed :(
  apk add make
fi

make build/mackerel-check
mv build bin
./bin/mackerel-check --help
cd ..
mv go-check-plugins/bin .

# detect if this is musl or libc
libc=glibc
musl=$(ldd /bin/ls | grep 'musl' | head -1 | cut -d ' ' -f1)
if [ $musl ]; then
    libc=musl
fi

tar_name="mackerelio-check_${libc}_$(go env GOOS)-$(go env GOARCH).tgz"
tar -czvf ${ARTIFACT_DIR}/${tar_name} bin/
sha512sum ${ARTIFACT_DIR}/${tar_name} > ${ARTIFACT_DIR}/${tar_name}.sum
