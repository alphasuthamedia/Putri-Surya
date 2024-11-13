# Toko Putri Surya

### Toko Putri Surya, a Platform-Based Programming project, made by:
- Nama: Alpha Sutha Media
- NPM: 2306275935
- Kelas: PBP F

i dedicate this repo (ignore this)
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