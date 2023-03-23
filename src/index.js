import { NativeModules } from 'react-native';

// interface FileOptions {
//   targetPath: string;
//   content?: string;
// }

// type CloudStorage = {
//   isCloudAvailable(): boolean;
//   uploadFile(file: FileOptions): Promise<void>;
//   downloadFile(file: FileOptions): Promise<string>;
//   listFiles(): Promise<Array<string>>;
//   deleteFile(file: FileOptions): Promise<void>;
//   isFileExist(file: FileOptions): boolean;
// };

const { RNCloudStorage } = NativeModules;

// export default RNCloudStorage as CloudStorage;
export default RNCloudStorage;
