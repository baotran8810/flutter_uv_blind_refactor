enum Environment { dev, stag, prod }

class _EnvironmentData {
  late final Environment env;
  late final String baseRestApiUrl;
  late final int sleepTooLongInSeconds;
  late final String awsRegion;
  late final String awsIdentityPoolId;
  late final String oneSignalAppId;

  void setDevEnvironment() {
    env = Environment.dev;
    baseRestApiUrl = "https://api.univoice.sk-global.io/";
    sleepTooLongInSeconds = 60;
    awsRegion = "ap-northeast-1";
    awsIdentityPoolId = "ap-northeast-1:9de1b333-249b-4d04-a3a6-d295e2db322d";
    oneSignalAppId = "5000f209-4d22-4c5a-9a85-1953a32b7b2f";
  }

  void setStagEnvironment() {
    env = Environment.stag;
    baseRestApiUrl = "https://test-api.uni-voice.biz/";
    sleepTooLongInSeconds = 60;
    awsRegion = "ap-northeast-1";
    awsIdentityPoolId = "ap-northeast-1:9de1b333-249b-4d04-a3a6-d295e2db322d";
    oneSignalAppId = "877c3e5c-895d-4292-9618-31b806e49db5";
  }

  void setProdEnvironment() {
    env = Environment.prod;
    baseRestApiUrl = "https://api.uni-voice.biz/";
    sleepTooLongInSeconds = 300;
    awsRegion = "ap-northeast-1";
    awsIdentityPoolId = "ap-northeast-1:9de1b333-249b-4d04-a3a6-d295e2db322d";
    oneSignalAppId = "d704ce92-dbdf-4278-9ef2-a58818581036";
  }
}

final appEnvData = _EnvironmentData();
