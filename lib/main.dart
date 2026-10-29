import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() { runApp(const JxMobilShopApp()); }

class JxMobilShopApp extends StatelessWidget {
  const JxMobilShopApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JX Mobil Shop',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> phones = [];
  final ImagePicker _picker = ImagePicker();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final priceController = TextEditingController();
  XFile? selectedImage;

  Future<void> pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) { setState(() => selectedImage = img); }
  }

  void addPhone() {
    if (brandController.text.isEmpty) return;
    setState(() {
      phones.add({'brand': brandController.text, 'model': modelController.text, 'price': priceController.text, 'image': selectedImage});
      brandController.clear(); modelController.clear(); priceController.clear(); selectedImage = null;
    });
    Navigator.pop(context);
  }

  void showAddDialog() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('নতুন ফোন'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
        TextField(controller: modelController, decoration: const InputDecoration(labelText: 'Model')),
        TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: pickImage, child: Text(selectedImage == null ? 'ছবি সিলেক্ট করুন' : 'ছবি সিলেক্ট হয়েছে')),
      ])),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('বাতিল')), ElevatedButton(onPressed: addPhone, child: const Text('যোগ করুন'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JX - মোবিল শো'), centerTitle: true),
      body: phones.isEmpty ? const Center(child: Text('কোন ফোন নেই\n+ চাপুন')) : ListView.builder(
        itemCount: phones.length,
        itemBuilder: (c,i){
          final p = phones[i];
          return Card(margin: const EdgeInsets.all(8), child: ListTile(
            leading: p['image']!=null ? Image.file(File(p['image'].path), width:50, height:50, fit:BoxFit.cover) : const Icon(Icons.phone_android, size:40),
            title: Text("${p['brand']} ${p['model']}"), subtitle: Text("দাম: ${p['price']}"),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: ()=>setState(()=>phones.removeAt(i))),
          ));
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: showAddDialog, child: const Icon(Icons.add)),
    );
  }
}
