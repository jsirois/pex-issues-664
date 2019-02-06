#!/usr/bin/env bash

cd "$(git rev-parse --show-toplevel)"

curl -SL https://github.com/pantsbuild/pex/releases/download/v1.6.1/pex27 -O
chmod +x pex27
./pex27 -vvv . -m example -o build/example

echo "Should work:"
./build/example

pth_file="$(PEX_INTERPRETER=1 ./build/example -c 'import site; print(site.getsitepackages()[0])')/problematic.pth"
sudo sh -c "echo "${PWD}" > "${pth_file}""
trap "sudo rm "${pth_file}"" EXIT
echo "Created "${pth_file}" with contents $(cat "${pth_file}") and now should fail:"
./build/example
