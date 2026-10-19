import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/services/firestore_service.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String device = '';
  bool uploading = false;
  @override
  void initState() {
    super.initState();
    loadDevice();
  }

  Future<void> loadDevice() async {
    try {
      final info = await DeviceInfoPlugin().deviceInfo;
      if (mounted) {
        setState(() => device = info.data.entries
            .take(5)
            .map((e) => '${e.key}: ${e.value}')
            .join('\n'));
      }
    } catch (_) {}
  }

  Future<void> changePhoto() async {
    final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 65, maxWidth: 900);
    if (picked == null) {
      return;
    }
    setState(() => uploading = true);
    try {
      final ref = FirebaseStorage.instance
          .ref('profiles/${FirebaseAuth.instance.currentUser!.uid}/avatar.jpg');
      await ref.putData(await picked.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'));
      await FirestoreService.instance.savePhotoUrl(await ref.getDownloadURL());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.photoUpdated),
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.error)));
      }
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(title: Text(l.profile)),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirestoreService.instance.profile(),
            builder: (context, snapshot) {
              final data = snapshot.data?.data() ?? {};
              final url = data['photoUrl'] as String?;
              return ListView(padding: const EdgeInsets.all(20), children: [
                Center(
                    child: CircleAvatar(
                        radius: 46,
                        backgroundImage: url == null ? null : NetworkImage(url),
                        child: url == null
                            ? const Icon(Icons.person, size: 44)
                            : null)),
                Center(
                    child: TextButton.icon(
                        onPressed: uploading ? null : changePhoto,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(l.profile))),
                Text((data['name'] ?? user.displayName ?? '').toString(),
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(user.email ?? ''),
                const Divider(),
                Text(l.device, style: Theme.of(context).textTheme.titleMedium),
                Text(device),
                const Divider(),
                Text(l.myOrders, style: Theme.of(context).textTheme.titleLarge),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirestoreService.instance.orders(),
                    builder: (context, s) {
                      if (s.hasError) return Text(l.error);
                      if (!s.hasData) return const LinearProgressIndicator();
                      if (s.data!.docs.isEmpty) return Text(l.noOrders);
                      return Column(
                          children: s.data!.docs
                              .map((d) => ListTile(
                                  title:
                                      Text('${l.total}: ${d.data()['total']}'),
                                  subtitle: Text(
                                      '${l.orderStatus}: ${d.data()['status']}')))
                              .toList());
                    }),
                const Divider(),
                Text(l.favourites,
                    style: Theme.of(context).textTheme.titleLarge),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirestoreService.instance.favourites(),
                    builder: (context, s) {
                      if (s.hasError) return Text(l.error);
                      if (!s.hasData) return const LinearProgressIndicator();
                      if (s.data!.docs.isEmpty) return Text(l.noFavourites);
                      return Column(
                          children: s.data!.docs
                              .map((d) => ListTile(
                                  title: Text(
                                      (d.data()['name'] ?? '').toString())))
                              .toList());
                    }),
                OutlinedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text(l.logout))
              ]);
            }));
  }
}

/// Device-gated entry point. No bypass if authentication is unavailable.
Future<void> openProtectedProfile(BuildContext context) async {
  final l = AppLocalizations.of(context)!;
  try {
    final auth = LocalAuthentication();
    final available =
        await auth.canCheckBiometrics && await auth.isDeviceSupported();
    if (!available) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.biometricUnavailable)));
      }
      return;
    }
    final ok = await auth.authenticate(
        localizedReason: l.openProfile,
        options: const AuthenticationOptions(biometricOnly: true));
    if (ok && context.mounted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.biometricUnavailable)));
    }
  }
}
