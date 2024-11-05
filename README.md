# Toko Putri Surya

### Toko Putri Surya, a Platform-Based Programming project, made by:
- Nama: Alpha Sutha Media
- NPM: 2306275935
- Kelas: PBP F

i dedicate this repo (ignore this)

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