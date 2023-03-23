import { NativeModules } from 'react-native';

type CloudStorage = {
  isCloudAvailable(): Promise<boolean>;
  uploadFile(file: string): Promise<string>;
};

const { RNCloudStorage } = NativeModules;

export default RNCloudStorage as CloudStorage;
