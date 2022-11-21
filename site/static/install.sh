
#!/bin/bash
## **This is an autogenerated file, do not change it manually**

if test -z "$BASH_VERSION"; then
  echo "Please run this script using bash, not sh or any other shell." >&2
  exit 1
fi

install() {
  set -euo pipefail

  dst_dir="${K14SIO_INSTALL_BIN_DIR:-/usr/local/bin}"

  if [ -x "$(command -v wget)" ]; then
    dl_bin="wget -nv -O-"
  else
    dl_bin="curl -s -L"
  fi

  shasum -v 1>/dev/null 2>&1 || (echo "Missing shasum binary" && exit 1)

  if [[ `uname` == Darwin ]]; then
    binary_type=darwin-amd64
    
    ytt_checksum=a50a8065c6d80226aa979bb708992ca4da9dd2ec2df2c6c4d5c6e9b4b9f3e6f8
    imgpkg_checksum=a4dadd5fa632a619158968d4c384d31e16fdc6738503426483a6e5bc929e8225
    kbld_checksum=f0fa574d1dd1c4dcd6a763d38e746a918477ac61a6cd52e8e9e1bba6714259c9
    kapp_checksum=2b466b9f8bbc8719334cadf917769b27affc10c95c9ded3e76be283cfd3d4721
    kwt_checksum=555d50d5bed601c2e91f7444b3f44fdc424d721d7da72955725a97f3860e2517
    vendir_checksum=5964af6123563b63cad7b9b5525d49814f8f2048a75bb811888d87618a358c30
    kctrl_checksum=70d4c564ff332eeca0ceba713cc7d882364700108a8be5da1feecf8b387db01a
  else
    binary_type=linux-amd64
    
    ytt_checksum=b3fbce9c6828c7eea09491c24fe49ddba7afe09e4405db33373d2776c91b1e6c
    imgpkg_checksum=e9b69dfd38e6d09f87ddbf8b2356cbf4d41172a84304640ecafe6be4841304d9
    kbld_checksum=1c3f0e4171063eef70cdabf1730d3557af992aeafb423755e71e9d5f1aea2c9b
    kapp_checksum=c2c7381a152216c8600408b4dee26aee48390f1e23d8ef209af8d9eb1edd60fc
    kwt_checksum=92a1f18be6a8dca15b7537f4cc666713b556630c20c9246b335931a9379196a0
    vendir_checksum=0b52c170f4a30c2b6213ff0048ecc89c9c25c3e4da56eb1e095fcdb335bd82ed
    kctrl_checksum=8b1c8a59817b3e1d26a3fadb6deb5baefaaaa8aec61a38daec3034edbca65d9b
  fi

  echo "Installing ${binary_type} binaries..."

  
  echo "Installing ytt..."
  $dl_bin github.com/vmware-tanzu/carvel-ytt/releases/download/v0.44.0/ytt-${binary_type} > /tmp/ytt
  echo "${ytt_checksum}  /tmp/ytt" | shasum -c -
  mv /tmp/ytt ${dst_dir}/ytt
  chmod +x ${dst_dir}/ytt
  echo "Installed ${dst_dir}/ytt v0.44.0"
  
  echo "Installing imgpkg..."
  $dl_bin github.com/vmware-tanzu/carvel-imgpkg/releases/download/v0.34.0/imgpkg-${binary_type} > /tmp/imgpkg
  echo "${imgpkg_checksum}  /tmp/imgpkg" | shasum -c -
  mv /tmp/imgpkg ${dst_dir}/imgpkg
  chmod +x ${dst_dir}/imgpkg
  echo "Installed ${dst_dir}/imgpkg v0.34.0"
  
  echo "Installing kbld..."
  $dl_bin github.com/vmware-tanzu/carvel-kbld/releases/download/v0.35.0/kbld-${binary_type} > /tmp/kbld
  echo "${kbld_checksum}  /tmp/kbld" | shasum -c -
  mv /tmp/kbld ${dst_dir}/kbld
  chmod +x ${dst_dir}/kbld
  echo "Installed ${dst_dir}/kbld v0.35.0"
  
  echo "Installing kapp..."
  $dl_bin github.com/vmware-tanzu/carvel-kapp/releases/download/v0.53.0/kapp-${binary_type} > /tmp/kapp
  echo "${kapp_checksum}  /tmp/kapp" | shasum -c -
  mv /tmp/kapp ${dst_dir}/kapp
  chmod +x ${dst_dir}/kapp
  echo "Installed ${dst_dir}/kapp v0.53.0"
  
  echo "Installing kwt..."
  $dl_bin https://github.com/vmware-tanzu/carvel-kwt/releases/download/v0.0.6/kwt-${binary_type} > /tmp/kwt
  echo "${kwt_checksum}  /tmp/kwt" | shasum -c -
  mv /tmp/kwt ${dst_dir}/kwt
  chmod +x ${dst_dir}/kwt
  echo "Installed ${dst_dir}/kwt v0.0.6"
  
  echo "Installing vendir..."
  $dl_bin github.com/vmware-tanzu/carvel-vendir/releases/download/v0.32.0/vendir-${binary_type} > /tmp/vendir
  echo "${vendir_checksum}  /tmp/vendir" | shasum -c -
  mv /tmp/vendir ${dst_dir}/vendir
  chmod +x ${dst_dir}/vendir
  echo "Installed ${dst_dir}/vendir v0.32.0"
  
  echo "Installing kctrl..."
  $dl_bin github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.41.3/kctrl-${binary_type} > /tmp/kctrl
  echo "${kctrl_checksum}  /tmp/kctrl" | shasum -c -
  mv /tmp/kctrl ${dst_dir}/kctrl
  chmod +x ${dst_dir}/kctrl
  echo "Installed ${dst_dir}/kctrl v0.41.3"
  
}

install
