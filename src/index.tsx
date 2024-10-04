import { NativeModules } from 'react-native';

interface FileOptions {
  targetPath: string;
  content?: string;
  newName?: string;
}

interface ListOptions {
  includeSize?: boolean;
}

interface FileObject {
  url: string;
  name: string;
  size?: number;
}

type CloudStorage = {
  isCloudAvailable(): Promise<boolean>;
  uploadFile(file: FileOptions): Promise<void>;
  downloadFile(file: FileOptions): Promise<string>;
  listFiles(options?: ListOptions): Promise<Array<FileObject>>;
  deleteFile(file: FileOptions): Promise<void>;
  isFileExist(file: FileOptions): Promise<boolean>;
  renameFile(file: FileOptions): Promise<void>;
  mkdir(options: FileOptions): Promise<void>;
};

const { RNCloudStorage } = NativeModules;

export default RNCloudStorage as CloudStorage;
