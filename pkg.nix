{ pkgs, buildGoModule, fetchFromGitHub }:

let
  googleapis = fetchFromGitHub {
    owner = "googleapis";
    repo = "googleapis";
    rev = "ef8a5429145c241dcb256b0b84fa8e477facc9e1";
    hash = "sha256-K0y7bXf7ehY168WFEHztNzLbh0sf1ZkyVF6A+QgMrRg=";
  };
in
buildGoModule rec {
  pname = "OliveTin";
  version = "2025.2.19";

  src = fetchFromGitHub {
    owner = "OliveTin";
    repo = pname;
    rev = version;
    hash = "sha256-Wa8hpykJ5iwr6jnh+TxM/QJhmvf1mkt2HuehiTZZnsc=";
  };

  subPackages = [
    "cmd/OliveTin"
  ];

  vendorHash = "sha256-gye9/rIYD1VuUWGRNWczk/0JEEyjZSDNBC2h8vPvEoE=";

  nativeBuildInputs = with pkgs;[
    buf
    grpc-gateway
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    python3
    nodejs
  ];

  preBuild = ''
    protoc --go_out=. --go-grpc_out=require_unimplemented_servers=false:. --grpc-gateway_out=. -I${googleapis}:$src OliveTin.proto
  '';
}
