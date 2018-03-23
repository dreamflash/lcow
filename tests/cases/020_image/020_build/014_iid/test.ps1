# SUMMARY: Simple docker build test with iid file
# LABELS:
# REPEAT:

$libBase = Join-Path -Path $env:RT_PROJECT_ROOT -ChildPath _lib
$lib = Join-Path -Path $libBase -ChildPath lib.ps1
. $lib

$ret = 0

$imageName = $env:RT_TEST_NAME
$imageIIDFile = Join-Path -Path $env:TEST_TMP -ChildPath iid.file

Remove-Item -Force -Recurse -ErrorAction Ignore -Path $env:TEST_TMP
New-Item -ItemType Directory -Force -Path $env:TEST_TMP

docker build --platform linux -t $imageName --iidfile $imageIIDFile .
if ($lastexitcode -ne 0) {
    exit 1
}

if (!(Test-Path -Path $imageIIDFile)) {
    exit 1
}

$iid = Get-Content $imageIIDFile -Raw 

docker inspect $iid
if ($lastexitcode -ne 0) {
    $ret = 1
}

docker rmi --force $iid
if ($lastexitcode -ne 0) {
    $ret = 1
}

Remove-Item -Force -Recurse -ErrorAction Ignore -Path $env:TEST_TMP
exit $ret