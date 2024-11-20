# Toko Putri Surya

### Toko Putri Surya, a Platform-Based Programming project, made by:
- Nama: Alpha Sutha Media
- NPM: 2306275935
- Kelas: PBP F

i dedicate this repo (ignore this)
### Pertanyaan Tugas 0
1. model diperlukan sebagai kerangka dasar atau tubuh, hasil dari model tersebut akan diberikan data, bisa diibaratkan sebagai model adalah ruangannya dan data atau json adalah isi dalam gedung tersebut. selain itu kita perlu mendefinisikan datatipe juga dengan model. sebenarnya tanpa membuat model bisa, tapi akan sangat sulit untuk dikelola, otomatis json akan ditampilkan secara live.

2. library http bertugas sebagai perantara django dan flutter, dengan library http inilah kita dimungkinkan untuk melakukan fetch data dan melakukan komunikasi dengen django api menggunakan method post dan get
```dart
final response = await request.logout(
                    "http://127.0.0.1:8000/auth/logout/");
```
diatas adalah contoh implementasi library http, tanpa library http request tidak akan bisa digunakan

3. CookieRequest adalah kelas yang menangani sesi pengguna dengan cara menyimpan dan mengirim cookie secara otomatis. ini sangat berguna terutama untuk aplikasi yang membutuhkan autentikasi berbasis sesi seperti ketika menggunakan django dengan middleware auth. CookieRequest perlu dibagikan ke seluruh komponen agar mendukung sesi yang konsisten dimana semua komponen di aplikasi membutuhkan akses ke status sesi pengguna untuk menampilkan data yang relevan. selain itu juga dapat mempermudah pemantauan Status di Seluruh Aplikasi Jika menggunakan package seperti Provider untuk membagikan instance, setiap perubahan pada CookieRequest (seperti login atau logout) akan secara otomatis memberitahu komponen lain yang memantau perubahan tersebut.

4. yang pertama kita sebgai naive end user melakukan input data di flutter melalui halaman product_form.dart dan setelah input terisi dan kit amenekan tombol submit data yang diinput akan dikirim ke backend django menggunakan instance cookierequest. data tersebut diserealisasi dan dikirimkan dengan bentuk json di bagian body dari request. proses backend django seperti biasa diterima di url diproses di view lalu hasil dari proses dari view akan mengembalikan response. setelah berhasil maka flutter akan menerima response dengan bentuk json dari server django. hasil dari respon json tersebut akan di decode dan dibuah menjadi objek dart menggunakan model yang sesuai. lalu terakhir flutter akan mengambil data berdasarkan model tersebut (opsional, bisa aja kirim data aja gak ada lihat data)

5. proses login dimuali dari user input data dan klik submit, setelah klik submit data yang disubmit akan dikirim ke endpoint django menggunakan instance CookieRequest dalam format json. django akan validasi seperti biasa dan akan mereturn error atau berhasil (return datanya) setelah berhasil Cookie akan disimpan di CookieRequest untuk digunakan personailiasasi di dalam aplikasi. sementara proses register sebenarnya sama saja dengan proses login hanya saja proses register jika datanya sudah berhasil diproses di backend dan backend mengirim notifikasi sukses maka akan menampilkan notifikasi sukses dan data pengguna akan disimpat jika gagal akan menampilkan notifikasi gagal. untuk proses logout sama saja tapi seperti dibalik, kita akan melakukan request untuk logout jika menekan tombol log out menggunakan cookie request, lalu jika berhasil cookie akan dihapus, django akan menghapus sesi pengguna sehingga cookie authentikasi menjadi tidak akan valid. dan cookierequest  menjadi kosong karena telah diperbarui dari apliaksi flutter, dengan demikian pengguna akan diarahkan untuk login kembali.

---
langkah langkah implementasi
1. buat view untuk menangani login logout dan register  gunakan django yang kemarin dan buat modul baru yaitu modul auth
```py
from django.contrib.auth import authenticate, login as auth_login
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
import json
from django.contrib.auth import logout as auth_logout


@csrf_exempt
def login(request):
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            auth_login(request, user)
            # Status login sukses.
            return JsonResponse({
                "username": user.username,
                "status": True,
                "message": "Login sukses!"
                # Tambahkan data lainnya jika ingin mengirim data ke Flutter.
            }, status=200)
        else:
            return JsonResponse({
                "status": False,
                "message": "Login gagal, akun dinonaktifkan."
            }, status=401)

    else:
        return JsonResponse({
            "status": False,
            "message": "Login gagal, periksa kembali email atau kata sandi."
        }, status=401)
        
@csrf_exempt
def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data['username']
        password1 = data['password1']
        password2 = data['password2']

        # Check if the passwords match
        if password1 != password2:
            return JsonResponse({
                "status": False,
                "message": "Passwords do not match."
            }, status=400)
        
        # Check if the username is already taken
        if User.objects.filter(username=username).exists():
            return JsonResponse({
                "status": False,
                "message": "Username already exists."
            }, status=400)
        
        # Create the new user
        user = User.objects.create_user(username=username, password=password1)
        user.save()
        
        return JsonResponse({
            "username": user.username,
            "status": 'success',
            "message": "User created successfully!"
        }, status=200)
    
    else:
        return JsonResponse({
            "status": False,
            "message": "Invalid request method."
        }, status=400)

@csrf_exempt
def logout(request):
    username = request.user.username

    try:
        auth_logout(request)
        return JsonResponse({
            "username": username,
            "status": True,
            "message": "Logout berhasil!"
        }, status=200)
    except:
        return JsonResponse({
        "status": False,
        "message": "Logout gagal."
        }, status=401)
```
2. buat urls untuk menangani authentication tersebut
```py
from django.urls import path
from authentication.views import *

app_name = 'authentication'

urlpatterns = [
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('logout/', logout, name='logout'),
]
```
3. setelah kita urus backend kita urus aplikais flutter kita, yaitu dengan membuat stateful papge dan form input, lalu kita buat logic untuk tombol registrasi
```dart
final response = await request.postJson(
  "http://localhost:8000/auth/register/",
  jsonEncode({
    "username": username,
    "password1": password1,
    "password2": password2,
  }));
```
jangan lupa logic berhasil dan tidaknya saat register
```dart
if (response['status'] == 'success') {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
	content: Text('Successfully registered!'),
),
);
Navigator.pushReplacement(
context,
MaterialPageRoute(
	builder: (context) => const LoginPage()),
);
} else {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
	content: Text('Failed to register!'),
),
);
}
```
4. sekarang kita handle login page
```dart
ElevatedButton(
	onPressed: () async {
		String username = _usernameController.text;
		String password = _passwordController.text;

		// Cek kredensial
		// Untuk menyambungkan Android emulator dengan Django pada localhost,
		// gunakan URL http://10.0.2.2/
		final response = await request
			.login("http://127.0.0.1:8000/auth/login/", {
		'username': username,
		'password': password,
		});

		if (request.loggedIn) {
		String message = response['message'];
		String uname = response['username'];
		if (context.mounted) {
			Navigator.pushReplacement(
			context,
			MaterialPageRoute(
				builder: (context) => MyHomePage()),
			);
			ScaffoldMessenger.of(context)
			..hideCurrentSnackBar()
			..showSnackBar(
				SnackBar(
					content:
						Text("$message Selamat datang, $uname.")),
			);
		}
		} else {
		if (context.mounted) {
			showDialog(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text('Login Gagal'),
				content: Text(response['message']),
				actions: [
				TextButton(
					child: const Text('OK'),
					onPressed: () {
					Navigator.pop(context);
					},
				),
				],
			),
			);
		}
		}
	},
	style: ElevatedButton.styleFrom(
		foregroundColor: Colors.white,
		minimumSize: Size(double.infinity, 50),
		backgroundColor: Theme.of(context).colorScheme.primary,
		padding: const EdgeInsets.symmetric(vertical: 16.0),
	),
	child: const Text('Login'),
	),
```
demikian kita buat aelevated button dan handling bila berhasil tidaknya saat login
5. fetch dari endpoint json
```dart
Future<List<ProductEntry>> fetchMood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object MoodEntry
    List<ProductEntry> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(ProductEntry.fromJson(d));
      }
    }
    return listMood;
  }
```
6. ini untuk attributenya saja yang nanti akan kita call
```dart
// To parse this JSON data, do
//
//     final ProductEntry = ProductEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> ProductEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String ProductEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    String model;
    String pk;
    Fields fields;

    ProductEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String name;
    int price;
    String description;
    int quantity;

    Fields({
        required this.user,
        required this.name,
        required this.price,
        required this.description,
        required this.quantity,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "name": name,
        "price": price,
        "description": description,
        "quantity": quantity,
    };
}

```
7. buat futurebuilder untuk menampilkan loader setiap data yang sedang difetch
```dart
body: FutureBuilder(
	future: fetchMood(request),
	builder: (context, AsyncSnapshot snapshot) {
		if (snapshot.data == null) {
		return const Center(child: CircularProgressIndicator());
		} else {
		if (!snapshot.hasData) {
			return const Column(
			children: [
				Text(
				'Belum ada data barang di Toko Putri Surya.',
				style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
				),
				SizedBox(height: 8),
			],
			);
		} else {
			return ListView.builder(
			itemCount: snapshot.data!.length,
			itemBuilder: (_, index) => Container(
				margin:
					const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
				padding: const EdgeInsets.all(20.0),
				child: Column(
				mainAxisAlignment: MainAxisAlignment.start,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(
					"${snapshot.data![index].fields.name}",
					style: const TextStyle(
						fontSize: 18.0,
						fontWeight: FontWeight.bold,
					),
					),
					const SizedBox(height: 10),
					Text("${snapshot.data![index].fields.description}"),
					const SizedBox(height: 10),
					Text("${snapshot.data![index].fields.price}"),
					const SizedBox(height: 10),
					Text("${snapshot.data![index].fields.quantity}")
				],
				),
			),
			);
		}
		}
	},
	),
```

### Pertanyaan Tugas 8
1. Apa kegunaan const di Flutter? Jelaskan apa keuntungan ketika menggunakan const pada kode Flutter. Kapan sebaiknya kita menggunakan const, dan kapan sebaiknya tidak digunakan?
	const sebaiknya tidak digunakan untuk widget atau data yang nilainya berubah ubah selama runtime, jadi seharusnya gunakan const untuk widget atau data yang nilainya konstan, dan tidak ada perubahan saat runtime.
	keuntungan menggunakan const:
	- ketika kita menggunakan const, nilai dari const tidak akan bisa berubah, 	ini bisa menjadi salah satu cara kita untuk memastikan variabel tersebut tidak berubah nilainya, jika berubah akan terjadi error jadi meminimalisasi bug
	- dengan menggunakan const kita akan menghindari rebuilding dari objek, hal ini pasti meringankan kinerja dari program kita.
	- widget pada const hanya perlu untuk dibuat sekali dan tidak perlu dirender ulang atau direbuild lagi, hal ini akan membuat keuntungan berupa penghematan memori yang sangat signifikan jika memang banyak widget yang tidak kita gunakan const

2. Jelaskan dan bandingkan penggunaan Column dan Row pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
	- Row - baris, column - kolom. sebenarnya cukup sederhana, row akan memetakan (seperti menjadi container) baris ke baris, jika ada elemen baru maka akan diletakkan dibawah elemen yang tadi, sementara column akan memetakan kolom ke kolom, jadi jika ada elemen baru maka akan diletakkan disamping elemen yang tadi.
	contoh implementasi
	```dart
	child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row untuk menampilkan 3 InfoCard secara horizontal.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
              ],
            ),

            // Memberikan jarak vertikal 16 unit.
            const SizedBox(height: 16.0),

            // Menempatkan widget berikutnya di tengah halaman.
            Center(
              child: Column(
                // Menyusun teks dan grid item secara vertikal.

                children: [
                  // Menampilkan teks sambutan dengan gaya tebal dan ukuran 18.
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Selamat datang di Toko Putri Surya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // Grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom.
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    // Agar grid menyesuaikan tinggi kontennya.
                    shrinkWrap: true,

                    // Menampilkan ItemCard untuk setiap item dalam list items.
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
	```
	di dalam kode tersebut terdapat wrapper column yang di dalam wrapper column terdapat beberapa childer seperti row, seeprti ini bisa dibayang wrapper utamanya berdasarkan kolum, di kolumn pertama ada beberapa wrappingan beradasrkan row

3. Sebutkan apa saja elemen input yang kamu gunakan pada halaman form yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!
	1. **TextFormField**: digunakan untuk memasukkan teks dari pengguna.
   - Field untuk **Product Name** (`_productName`), menerima teks biasa.
   - Field untuk **Product Price** (`_productPrice`), diharapkan menerima angka melalui percobaan parsing.
   - Field untuk **Product Description** (`_productDescription`), menerima teks deskripsi produk.
   - Field untuk **Product Quantity** (`_productQuantity`), menerima teks tapi diparsing (dicoba parsing) untuk dirubah menajadi interger

	2. **ElevatedButton**: digunakan sebagai tombol untuk menyimpan data. Tombol ini men-*trigger* validasi form dan menampilkan dialog konfirmasi.

4. Bagaimana cara kamu mengatur tema (theme) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
	Kita bisa gunakan ThemeData. ya saya mengimplementasikannya
	```dart
	theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
        useMaterial3: true,
      ),
	```

5. Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?
	Kita gunakan bantuan dari widget navigator. kita bisa gunakan Navigator.push untuk memasukkan suatu route ke dalam stack route yang dikelola oleh navigator. selain itu kita juga bisa gunakan Navigator.pushReplacement yang berguna untuk menghapus route yang sedang ditampilkan oleh pengguna dan menggantinya dengan suatu route tersebut (yang akan ditambahkan itu)

### Pertanyaan Tugas 7 

1. Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.
	- Stateless widget adalah widget yang tidak memiliki state atau dalam kaata lain statenya tidak dapat dirubah (immutable) semenjak widget tersebut pertama kali dibuat. Saat widget stateless dibuat, perubahan variabel, ikon, tambol, atau pengambilan data tidak akan merubah sate dari widget tersebut.
	- Stateful widget adalah widget yang memiliki state atau bisa dibilang widget ini statenya dapat berubah ubah (mutable). Setelah widget tersebut dibuat, state dari aplikasi dapat berubah ubah sesuai dengan input, variabel, dan data yang diberikan. Class yang menginherit stateful widget bersifat immutable, tetapi statnya bersifat mutable dan dapat berinteraksi dengan user.
	
2. Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.
	- Scaffold : Scaffold adalah kerangka dasar sekaligus kerangka untama dalam pengembangan proyek ini. Scaffold berfungsi untuk menaruh elemen elemen lain yang akan kita gunakan nanti, dalam kata lain scaffold adalah elemen dasar
	- MaterialApp : sebenearnya MaterialApp lebih dasar daripada Scaffold, MaterialApp adalah widget utama untuk aplikasi flutter yang menyediakan struktur dasar aplikasi mobile termasuk pengaturan tema dan home dari sebuah halaman. MaterialApp ini digunakan sebagai core componen dari sebuah flutter app. MaterialApp ini mengimplement material design untuk iOS, Android, dan Web, hanyasaja CuppertinoAPP lebih disarangkan karena lebih mengimplement iOS design (lebih spesifik -> lebih premium)
	- AppBar : Menampilkan kayak semacam navbar yang ada tulisan Toko Putri Surya.
	- Text : A static text
	- Padding : Mengatur jarak antara widget dan sekitarnya
	- Row : Semacam Kontainer untuk mengatur widget secara vertikal.
	- Column : Semacam kontainer untuk mengatur widget secara horizontal.
	- Card : Sebuah Widget berbentuk kotak yang dingunakan untuk menampilkan Nama Kelas dan NPM
	- Icon : ya Icon...
	- InkWell : Menambahkan efek ripple saat widget ditekan
	- ScaffoldMessenger : Untuk menampilkan Snackbar dan menghide Snackbar jika Snackbar masih showed
	- Snackbar : untuk Memunculkan anda telah memencet tombol .... di bawah naik ke atas
	- Container : seperti kontainer, bisa untuk mengwrap widget widget yang ada
	
3. Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.
	setState() adalah method atau fungsi yang disediakan oleh flutter untuk memberi tahu bahwa ada perubahan state yang akan dan harus dirender di-laya. setState() ini hanya berlaku pada StateFul widget, karena ya gimana kalau stateless kan statenya immutabel :). Sayangnya untuk projek kali ini kita tidak memiliki class yang mengextend stateful widget jadi setState() belum digunakan untuk tugas 7 kali ini.
	
4. Jelaskan perbedaan antara const dengan final.
	- const adalah variabel yang nilainya bersifat tetap dan tidak akan berubah selama aplikasi tersebut dijalankan (runtime). Biasa digunakan untuk widget widet yang statis.
	- final adalah variabel yang nilainya tetap setelah diinisialisasi. namun variabel dengan tipe final tidak mengharuskan untuk diketahui atau diinisialisasikan saat compile-time, jadi nilainya bisa diinisialisasi saat runtime hanya saja tidak bisa kalau nialinya diinisialisasi berkali kali.
	
5. Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.
	- Pertama inisiasi proyek baru dan kemudian berpindah ke direktori folder proyek tersebut.
	- Kemudian kita pindahkan beberapa class ke dalam menu.dart hal ini sebenarnya bisa saja dilakukan semua di main.dart hanya saja best practicenya demikian, dan kita hanya tinggal import menu.dart ke dalam main.dart
	- Pada main.dart saya rubah warna proyek aplikasi saya agar lebih menarik.
	- Setelah demikian saya rubah widget yang ada menjadi stateless. dengan demikian saya juga harus merubah const MyHomePage('....') menjadi hannya MyHomePage pada main.dart
	- Pada menu.dart kita hapus semua yang ada di class MyHomePage extend StatefulWidget dan merubahnya untuk menjadi extend StateLessWidget (kita rubah menjnadi stateless) dan kemudian kita tambahkan constructor MyHomePage({super.key});
	- karena MyHomePage kita stateless kita hapus saja semua class class _MyHomePageState extends State<MyHomePage>
	- Buat class InfoCard yang nanti kita akan build Card disana yang berisi nama, npm, kelas.
		`
		class InfoCard extends StatelessWidget {
		// Kartu informasi yang menampilkan title dan content.

		final String title;  // Judul kartu.
		final String content;  // Isi kartu.

		const InfoCard({super.key, required this.title, required this.content});

		@override
		Widget build(BuildContext context) {
			return Card(
			// Membuat kotak kartu dengan bayangan dibawahnya.
			elevation: 2.0,
			child: Container(
				// Mengatur ukuran dan jarak di dalam kartu.
				width: MediaQuery.of(context).size.width / 3.5, // menyesuaikan dengan lebar device yang digunakan.
				padding: const EdgeInsets.all(16.0),
				// Menyusun title dan content secara vertikal.
				child: Column(
				children: [
					Text(
					title,
					style: const TextStyle(fontWeight: FontWeight.bold),
					),
					const SizedBox(height: 8.0),
					Text(content),
				],
				),
			),
			);
		}
		}
		`
	- Lalu kita buat class baru bernama ItemHomePage seperti  di tutorial
	`
	class ItemHomepage {
        final String name;
        final IconData icon;
        final Color color;

        ItemHomepage(this.name, this.icon, this.color);
    }
	`
	- Lalu kita buat final Var List items yang berisi ItemHomePage sebagai berikut
	`
	final String npm = '2306275935'; // NPM
    final String name = 'Alpha Sutha Media'; // Nama
    final String className = 'PBP F'; // Kelas
	
	final List<ItemHomepage> items = [
         ItemHomepage("Lihat Daftar Produk", Icons.mood, Colors.blue.shade400),
         ItemHomepage("Tambah Produk", Icons.add, Colors.green.shade400),
         ItemHomepage("Logout", Icons.logout, Colors.purple.shade400),
    ];

    MyHomePage({super.key});
	`
	- Setelah itu buat kelas ItemCard untuk menampilkan tombol-tombol yang tadi kita tambahkan di MyHomePage
	`
	class ItemCard extends StatelessWidget {
	//Menampilkan kartu dengan ikon dan nama.

	  final ItemHomepage item; 
	  
	  const ItemCard(this.item, {super.key}); 
	 
	  @override
	Widget build(BuildContext context) {
		return Material(
		  // Menentukan warna latar belakang dari tema aplikasi.
		  // color: Theme.of(context).colorScheme.secondary,
		  color: item.color,
		  // Membuat sudut kartu melengkung.
		  borderRadius: BorderRadius.circular(12),
		  
		  child: InkWell(
			// Aksi ketika kartu ditekan.
			onTap: () {
			  // Menampilkan pesan SnackBar saat kartu ditekan.
			  ScaffoldMessenger.of(context)
				..hideCurrentSnackBar()
				..showSnackBar(
				  SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
				);
			},
			// Container untuk menyimpan Icon dan Text
			child: Container(
			  padding: const EdgeInsets.all(8),
			  child: Center(
				child: Column(
				  // Menyusun ikon dan teks di tengah kartu.
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: [
					Icon(
					  item.icon,
					  color: Colors.white,
					  size: 30.0,
					),
					const Padding(padding: EdgeInsets.all(3)),
					Text(
					  item.name,
					  textAlign: TextAlign.center,
					  style: const TextStyle(color: Colors.white),
					),
				  ],
				),
			  ),
			),
		  ),
		);
	  }
	}
	`
	- Terakhir kita integrasikan Infocard dan ItemCard ke dalam MyHomePage dengan mengubah sedikit bagian di widget build()
	`
	class MyHomePage extends StatelessWidget {
    final String npm = '2306275935'; // NPM
    final String name = 'Alpha Sutha Media'; // Nama
    final String className = 'PBP F'; // Kelas
    
    final List<ItemHomepage> items = [
         ItemHomepage("Lihat Daftar Produk", Icons.mood, Colors.blue.shade400),
         ItemHomepage("Tambah Produk", Icons.add, Colors.green.shade400),
         ItemHomepage("Logout", Icons.logout, Colors.purple.shade400),
    ];

    MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
	// Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
	return Scaffold(
	  // AppBar adalah bagian atas halaman yang menampilkan judul.
	  appBar: AppBar(
		// Judul aplikasi "Toko Putri Surya" dengan teks putih dan tebal.
		title: const Text(
		  'Toko Putri Surya',
		  style: TextStyle(
			color: Colors.white,
			fontWeight: FontWeight.bold,
		  ),
		),
		// Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
		backgroundColor: Theme.of(context).colorScheme.primary,
	  ),
	  // Body halaman dengan padding di sekelilingnya.
	  body: Padding(
		padding: const EdgeInsets.all(16.0),
		// Menyusun widget secara vertikal dalam sebuah kolom.
		child: Column(
		  crossAxisAlignment: CrossAxisAlignment.center,
		  children: [
			// Row untuk menampilkan 3 InfoCard secara horizontal.
			Row(
			  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			  children: [
				InfoCard(title: 'NPM', content: npm),
				InfoCard(title: 'Name', content: name),
				InfoCard(title: 'Class', content: className),
			  ],
			),

			// Memberikan jarak vertikal 16 unit.
			const SizedBox(height: 16.0),

			// Menempatkan widget berikutnya di tengah halaman.
			Center(
			  child: Column(
				// Menyusun teks dan grid item secara vertikal.

				children: [
				  // Menampilkan teks sambutan dengan gaya tebal dan ukuran 18.
				  const Padding(
					padding: EdgeInsets.only(top: 16.0),
					child: Text(
					  'Selamat datang di Toko Putri Surya',
					  style: TextStyle(
						fontWeight: FontWeight.bold,
						fontSize: 18.0,
					  ),
					),
				  ),

				  // Grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom.
				  GridView.count(
					primary: true,
					padding: const EdgeInsets.all(20),
					crossAxisSpacing: 10,
					mainAxisSpacing: 10,
					crossAxisCount: 3,
					// Agar grid menyesuaikan tinggi kontennya.
					shrinkWrap: true,

					// Menampilkan ItemCard untuk setiap item dalam list items.
					children: items.map((ItemHomepage item) {
					  return ItemCard(item);
					}).toList(),
				  ),
				],
			  ),
			),
		  ],
		),
	  ),
	);
  }
}