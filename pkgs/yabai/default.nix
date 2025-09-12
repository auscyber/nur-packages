{
  stdenv,
  apple-sdk_15,
  source,
  xxd,
}:
let
  inherit (stdenv.hostPlatform) system;

  target =
    {
      "aarch64-darwin" = "arm64e?";
      "x86_64-darwin" = "x86_64";
    }
    .${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "yabai";
  inherit (source) version src;
  buildInputs = [
    apple-sdk_15
    xxd
  ];
  doInstallCheck = true;
  preferLocalBuild = true;

  makeFlags = [
    "all"
  ];
  configurePhase = ''
    sed -i 's/-arch ${target}//g' makefile
  '';

  installPhase = ''
    runHook preInstall
     mkdir -p $out/bin
     cp ./bin/yabai $out/bin/yabai

    runHook postInstall
  '';

})
