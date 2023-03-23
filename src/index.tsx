import { NativeModules } from 'react-native';

type IcloudDocumentSyncType = {
  multiply(a: number, b: number): Promise<number>;
};

const { IcloudDocumentSync } = NativeModules;

export default IcloudDocumentSync as IcloudDocumentSyncType;
