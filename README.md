A. IDENTITAS
- Nama: Muhammad Rafli Wijaya
- NIM: 4243250017
- Kelas: PSIK 24D

B. DIAGRAM KELAS
- Diagram menggunakan mermaid diagram
![Screenshot diagram](./assets/mermaid-diagram.svg)

C. TANGKAPAN LAYAR OUTPUT
- OUTPUT
![Screenshot diagram](./assets/output.png)

- Dart Analyze
![Screenshot diagram](./assets/dartanalyze.png)

D. PENERAPAN ENKAPSULASI, POLIMORFISME DAN ASYNC
Pertama, enkapsulasi diterapkan pada kelas Parkiran. Field internal _kendaraanTerparkir (daftar kendaraan terparkir) dan _pendapatan (akumulasi kas) diberi awalan underscore _ jadi bersifat privat terhadap berkas (library-private). Akses dari luar dikontrol ketat melalui getter sisa dan pendapatan, sedangkan perubahan status data hanya dapat dilakukan melalui method terkendali masuk() dan keluar().

Kedua, polimorfisme diterapnkan melalui relasi pewarisan kelas abstrak kendaraan kepada subclass motor, mobil, truk, dan kelas MobilMember dengan mixin berlangganan. Pada fungsi main(), antrean kendaraan disimpan dalam satu koleksi seragam List<Kendaraan>. Saat method k.biaya() dan getter k.jenis dieksekusi secara dinamis saat runtime, Dart memanggil perilaku spesifik tiap kelas, termasuk diskon tarif 50% bagi member.

Ketiga, asynchronous programming diterapkan pada method masuk() dan keluar() menggunakan kata kunci async dan await. Simulasi jeda buka-tutup palang otomatis direpresentasikan lewat Future.delayed(). Selain itu tiap peristiwa masuk atau keluar ditampilkan secara real time tanpa memblokir thread utama menggunakan StreamController.broadcast(), yang kemudian ditangkap oleh listener monitor pos jaga.

E. PERNYATAAN PENGGUNAAN AI
Saya menggunakan ai untuk membuat/generate diagram sederhananya, kemudian membuat template dasar dari spesifikasi yang harus ada, kemudian barulah saya memodifikasinya dan menyatukannya. Saya juga menggunakan ai untuk menjelaskan maksud dari tantangan pratikum oop library sebelumnya, ketika masih tidak paham, saya menyuruh ai membut kodenya lalu menganalisis apa maksud dari tantangan tersebut kemudian mengetik ulang kode yang diberikan ai. 