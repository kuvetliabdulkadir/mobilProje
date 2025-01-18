# My Library - Kişisel Kitaplık Uygulaması

## Proje Açıklaması
My Library, kullanıcıların kütüphanesini dijital ortamda yönetmelerine olanak sağlayan bir mobil uygulamadır. Kullanıcılar kitaplarını ekleyebilir, düzenleyebilir, favorilerine alabilir ve kolayca arayabilirler.

|  Uygulama Özellikleri |
|----------------------------|
| - Kitap Ekleme, Silme, Düzenleme |
| - Eklenen Kitapları Favorilere Ekleme, Çıkarma |
| - Eklenen Kitapları Arama |
| - Kayıt ve Giriş |

|  Kullanılan Teknolojiler |
|----------------------------|
| - Flutter - Dart |
| - Firebase Firestore: Veri tabanı yönetimi |
| - Firebase Authentication: Kullanıcı doğrulama |

|  Proje Kullanılan Eklentiler | 
|----------------------------|
 | - firebase_core: ^2.32.0 |
 | - firebase_auth: ^4.16.0 |
 | - cloud_firestore: ^4.17.5 |
  

| Veritabanı Yapısı |
|----------------------------|
Firebase Cloud Firestore kullanılarak iki ana koleksiyon oluşturulmuştur.

| Kitaplar Koleksiyonu |
|----------------------------|
| - kitapAdi | 
| - yazarAdi | 
| - ozet | 
| - userId | 

| Favoriler Koleksiyonu |
|-----------------------|
| - kitapAdi |
| - yazarAdi |
| - ozet |
| - userId | 

##  Ekran Görüntüleri
| Kayıt Sayfası |
|----------------------------|
| - Yeni kullanıcı buradan adını, soyadını ,e-posta adresini ve bir parola girerek kaydını yapabilir. |
| ![kayitsayfası](https://github.com/user-attachments/assets/6e6bf29f-25a8-4696-b003-26f7fff49ca0) |

| Giriş Sayfası |
|----------------------------|
| - Kayıt olan kullanıcı e-posta adresini ve parolasını girerek uygulamaya giriş yapmaktadır. Burada kullanılan Firebase Authentication ile kullanıcı kimlik doğrulama sağlanır. |
| ![girissayfası](https://github.com/user-attachments/assets/c368a23a-8b22-4440-81de-f129eed383d1) | 

| Ana Sayfa |
|----------------------------|
| - Kullancı bu ekranda eklediği kitapları görebilir. |
| - Bulmak istediği kitapları arayabilir. |
| - Yandaki menüden diğer sayfalara geçiş yapablir. |
| - Ekrandaki artı butonuna tıklayarak da kitap ekleme sayfasına yönelndirilir. |
| ![anaekran](https://github.com/user-attachments/assets/1afaeb89-b8e7-4ba8-bcd7-818cf0f07b49) |

| Kitap Ekleme Sayfası |
|----------------------------|
| - Kullanıcı buradan kitap adı, yazar adı ve isterse kitabın özeti veya sevdiği bir bölümü yazarak kayıt edebilir. |
| ![kitapekle](https://github.com/user-attachments/assets/b7a8e821-a782-4442-b123-ef0b48ec85d1) |

| Kitap Liste Sayfası |
|----------------------------|
| - Kullanıcı bu sayfada eklediği kitapları üzerine tıklayarak düzenliyebilir. |
| - Kitabı favorilere ekliyebilir, favorilerden kaldırabilir. |
| - Kitabı isterse silebilir. |
| ![kitapliste](https://github.com/user-attachments/assets/9858d3f3-7fa6-4b92-bb55-bc1202d3fcd4) |

| Favoriler Sayfası |
|----------------------------|
| - Kullanıcı buradan favorilere eklediği kitabı görebilir ve favorilerden kaldırabilir. |
| ![favorisayfası](https://github.com/user-attachments/assets/88fb30b2-5038-4b20-818b-7a187fa4cb1c) |

| Kitap Silme Uyarısı |
|----------------------------|
| - Kullanıcı bir kitabı silmek isteiğinde onaylaması gerekmektedir. Bunun sebebi kitabı yanlışla silmenin önüne geçmek içindir. |
| ![kitapsilme](https://github.com/user-attachments/assets/92d2f1ce-c7bd-4c23-81e5-2a36cc65d26e) |

| Hesap Silme Uyarısı |
|----------------------------|
| - Kullanıcı hesabını silmek istediğinde onaylamsı gerekir. Bunun sebebi hesabı yanlışlıkla silmenin önüne geçmek içindir. |
| ![hesapsilme](https://github.com/user-attachments/assets/c3459d72-2e0a-4860-a331-a31d3e4b167f) |

- Projenin şuan genel çalışma mantığı kullanıcıların kitaplarını dijital ortama kaydedebilmesi ve düzenleyebilmesidir.

| Projeye Eklenecek Bazı Özellikler  |
|----------------------------|
| - Kategorilere göre filtreleme |
| - Kitap okuma durumu (okundu, okunuyor, okunacak) |
| - Kullanıcılar kendi aralarında kitap listesini veya favoriler listesini paylaşabilmesi |
| - Kullanıcı kendisi uygulama içinde kendi kitabını yazabilmesi. |

Aşağıdaki linkten projeyi anlattığım  youtube videosuna ulaşabilirsiniz. 
## [YouTube Videosu](https://youtu.be/KshkLmpNsKg?si=XUD8lDXZpM9JOopv)

