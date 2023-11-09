import * as React from 'react';
import { StyleSheet, View } from 'react-native';
import CloudStorage from 'react-native-icloud-document-sync';

export default function App() {
  React.useEffect(() => {
    (async () => {
      const isCloudAvailable = await CloudStorage.isCloudAvailable();
      console.log('isCloudAvailable', isCloudAvailable);
    })();
  }, []);

  return <View style={styles.container} />;
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
