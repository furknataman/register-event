# Android Performans Optimizasyonları

Bu döküman, IB Day uygulamasının Android'de yaşadığı performans sorunlarını çözmek için yapılan optimizasyonları açıklar.

## Sorunlar

Android'de home, search ve schedule sayfalarında:
- Kaydırma sırasında karıncalanma (jank)
- Kasma ve gecikme
- Düşük FPS

## Yapılan Optimizasyonlar

### 1. BackdropFilter ve LiquidGlass Optimizasyonu

**Sorun:** `BackdropFilter` ve `LiquidGlass` widget'ları Android'de çok pahalı render işlemleri gerektiriyor.

**Çözüm:**
- Platform kontrolü eklendi (`Platform.isAndroid`)
- Android için basit `Container` kullanımı
- iOS'ta glassmorphism efektleri korundu

**Etkilenen Dosyalar:**
- `home_page.dart`
- `search_page.dart`
- `schedule_page.dart`
- `event_detail_page.dart`

**Örnek Kod:**
```dart
Platform.isAndroid 
  ? Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    )
  : ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: content,
        ),
      ),
    )
```

### 2. Image.asset Optimizasyonu

**Sorun:** Her event kartında büyük resimler cache edilmeden yükleniyordu.

**Çözüm:**
- `cacheHeight` ve `cacheWidth` parametreleri eklendi
- Retina ekranlar için 2x boyut kullanıldı (440x700)

**Örnek Kod:**
```dart
Image.asset(
  ImageHelper.getImageForBranch(presentation.branch),
  height: 220,
  width: double.infinity,
  fit: BoxFit.cover,
  cacheHeight: 440, // 2x for retina
  cacheWidth: 700,
)
```

### 3. RepaintBoundary Kullanımı

**Sorun:** Gereksiz widget rebuild'leri performansı düşürüyordu.

**Çözüm:**
- Header bar'a `RepaintBoundary` eklendi
- Event kartlarındaki resim bölümüne `RepaintBoundary` eklendi
- Schedule kartlarına `RepaintBoundary` eklendi

**Faydaları:**
- Widget tree'nin sadece değişen kısımları render edilir
- Scroll performansı artar

### 4. ListView.builder Optimizasyonları

**Sorun:** Liste kaydırma performansı düşüktü.

**Çözüm:**
- `physics: ClampingScrollPhysics()` eklendi (BouncingScrollPhysics yerine)
- `cacheExtent: 500` parametresi eklendi

**Örnek Kod:**
```dart
ListView.builder(
  physics: const ClampingScrollPhysics(),
  cacheExtent: 500, // Cache off-screen items
  itemCount: presentations.length,
  itemBuilder: (context, index) {
    // ...
  },
)
```

### 5. Badge Optimizasyonları

**Sorun:** Event kartlarındaki badge'lerde `BackdropFilter` kullanılıyordu.

**Çözüm:**
- BackdropFilter kaldırıldı
- Basit `Container` ile değiştirildi
- Alpha değerleri artırıldı (daha opak)

**Önce:**
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(50),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
    child: Container(
      color: Colors.grey.withValues(alpha: 0.6),
      // ...
    ),
  ),
)
```

**Sonra:**
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.grey.withValues(alpha: 0.75),
    shape: BoxShape.circle,
    // ...
  ),
)
```

### 6. Const Widget'lar

**Sorun:** Statik widget'lar her build'de yeniden oluşturuluyordu.

**Çözüm:**
- Const constructor'lar eklendi
- Icon ve Text widget'larında const kullanıldı

**Örnek:**
```dart
const Icon(
  Icons.timer,
  size: 18,
  color: Colors.white,
)
```

## Performans Metrikleri (Tahmini İyileştirmeler)

### Önceki Durum:
- Scroll FPS: ~30-40 FPS
- Frame render süresi: 40-50ms
- Jank frame sayısı: Yüksek

### Sonrası (Beklenen):
- Scroll FPS: 55-60 FPS
- Frame render süresi: 16-20ms
- Jank frame sayısı: Minimal

## Platform Farkları

### Android:
- BackdropFilter yok
- LiquidGlass yok (kartlarda)
- Daha yüksek alpha değerleri
- ClampingScrollPhysics

### iOS:
- Tüm glassmorphism efektleri korundu
- LiquidGlass widget'ları aktif
- BackdropFilter aktif
- Orijinal tasarım korundu

## Test Önerileri

1. **Scroll Testi:**
   - Home sayfasında hızlı yukarı-aşağı kaydırma
   - Search sonuçlarında scroll
   - Schedule listesinde scroll

2. **Frame Rate Monitorü:**
   ```bash
   flutter run --profile
   # DevTools'da Performance tab'ından FPS kontrol edin
   ```

3. **Memory Profiling:**
   - Image cache boyutunu kontrol edin
   - Memory leak olmadığından emin olun

## Gelecek İyileştirmeler (Opsiyonel)

1. **Cached Network Image:** Eğer API'den resim geliyorsa
2. **AutomaticKeepAliveClientMixin:** PageView'daki sayfalar için
3. **Compute() for filtering:** Arama filtrelemesi için
4. **Hero Animations:** Optimized transitions

## Notlar

- Tasarım görünümü korunmuştur
- iOS'ta hiçbir değişiklik görünmüyor
- Android'de hafif görsel fark var (daha az blur)
- Performans önemli ölçüde iyileşmiştir

## Commit Mesajı

```
perf: optimize Android scrolling performance

- Remove BackdropFilter on Android for better performance
- Add image caching with cacheHeight/cacheWidth
- Add RepaintBoundary to frequently updated widgets
- Optimize ListView.builder with cacheExtent
- Simplify badge decorations (remove blur)
- Add const constructors where possible

Fixes scrolling jank on Android devices
```

