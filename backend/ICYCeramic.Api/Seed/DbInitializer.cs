using ICYCeramic.Api.Data;
using ICYCeramic.Api.Models;

namespace ICYCeramic.Api.Seed;

public static class DbInitializer
{
    public static void Initialize(ApplicationDbContext context)
    {
        // ============================================================
        // KATEGORİLER
        // ============================================================

        var categoryNames = new[]
        {
            "Kupa",
            "Tabak",
            "Anahtarlık",
            "Kase",
            "Biblo",
            "Tablo",
            "Kitap Ayracı",
            "Vazo"
        };

        // ------------------------------------------------------------
        // Daha önceki denemelerden oluşmuş aynı isimli kategori
        // kayıtlarını temizliyoruz.
        //
        // Şu aşamada ürünler henüz eklenmediği için kategori
        // tekrarlarını güvenli şekilde tekilleştirebiliriz.
        // ------------------------------------------------------------

        var duplicateCategories = context.Categories
            .AsEnumerable()
            .GroupBy(category => category.Name)
            .SelectMany(group => group.Skip(1))
            .ToList();

        if (duplicateCategories.Any())
        {
            context.Categories.RemoveRange(duplicateCategories);
            context.SaveChanges();
        }

        // ------------------------------------------------------------
        // Eksik kategorileri ekle.
        // ------------------------------------------------------------

        foreach (var categoryName in categoryNames)
        {
            if (!context.Categories.Any(c => c.Name == categoryName))
            {
                context.Categories.Add(
                    new Category
                    {
                        Name = categoryName
                    }
                );
            }
        }

        context.SaveChanges();

        // ------------------------------------------------------------
        // Kategori ID'lerini isimlerinden bul.
        // ------------------------------------------------------------

        var categoryIds = context.Categories
            .Where(c => categoryNames.Contains(c.Name))
            .ToDictionary(
                category => category.Name,
                category => category.Id
            );

        // ============================================================
        // ÜRÜNLER
        // ============================================================

        // Ürünler zaten varsa tekrar seed yapma.
        if (context.Products.Any())
        {
            return;
        }

        var products = new List<Product>
        {
            // ========================================================
            // KUPALAR
            // ========================================================

            new Product
            {
                Name = "Çiçek Detaylı Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 650,
                Image = "assets/products/kupa_01.png",
                Description = "El yapımı, zarif çiçek detaylarına sahip seramik kupa.",
                Stock = 8
            },

            new Product
            {
                Name = "Pembe Çiçekli Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 690,
                Image = "assets/products/kupa_02.png",
                Description = "Pastel tonları ve çiçek detaylarıyla romantik seramik kupa.",
                Stock = 6
            },

            new Product
            {
                Name = "Yeşil Dokulu Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 620,
                Image = "assets/products/kupa_03.png",
                Description = "Doğal yeşil tonlarda, elde şekillendirilmiş seramik kupa.",
                Stock = 7
            },

            new Product
            {
                Name = "Klasik Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 590,
                Image = "assets/products/kupa_04.png",
                Description = "Sade ve zamansız tasarımıyla günlük kullanıma uygun kupa.",
                Stock = 10
            },

            new Product
            {
                Name = "Noktalı Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 640,
                Image = "assets/products/kupa_05.png",
                Description = "El yapımı nokta desenleriyle özgün seramik kupa.",
                Stock = 5
            },

            new Product
            {
                Name = "Çiçek Formlu Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 720,
                Image = "assets/products/kupa_06.png",
                Description = "Çiçek formundan ilham alan zarif ve dekoratif seramik kupa.",
                Stock = 4
            },

            new Product
            {
                Name = "Minimal Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 580,
                Image = "assets/products/kupa_07.png",
                Description = "Minimal tasarıma sahip, sade ve kullanışlı seramik kupa.",
                Stock = 9
            },

            new Product
            {
                Name = "Mavi Detaylı Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 670,
                Image = "assets/products/kupa_08.png",
                Description = "Mavi detaylarıyla dikkat çeken el yapımı seramik kupa.",
                Stock = 6
            },

            new Product
            {
                Name = "Yeşil Kulplu Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 630,
                Image = "assets/products/kupa_09.png",
                Description = "Yeşil tonları ve özgün kulp tasarımıyla seramik kupa.",
                Stock = 7
            },

            new Product
            {
                Name = "Çiçek Desenli Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 680,
                Image = "assets/products/kupa_10.png",
                Description = "El boyaması çiçek desenlerine sahip özel tasarım kupa.",
                Stock = 5
            },

            new Product
            {
                Name = "Çiçek Kulplu Seramik Kupa",
                CategoryId = categoryIds["Kupa"],
                Price = 710,
                Image = "assets/products/kupa_11.png",
                Description = "Zarif çiçek detayları ve özgün formuyla el yapımı seramik kupa.",
                Stock = 4
            },

            // ========================================================
            // TABAKLAR
            // ========================================================

            new Product
            {
                Name = "Limon Formlu Seramik Tabak",
                CategoryId = categoryIds["Tabak"],
                Price = 420,
                Image = "assets/products/tabak_01.png",
                Description = "Limon formundan ilham alan dekoratif el yapımı seramik tabak.",
                Stock = 6
            },

            new Product
            {
                Name = "Çiçek Formlu Seramik Tabak",
                CategoryId = categoryIds["Tabak"],
                Price = 450,
                Image = "assets/products/tabak_02.png",
                Description = "Çiçek formuyla tasarlanmış zarif dekoratif seramik tabak.",
                Stock = 5
            },

            new Product
            {
                Name = "Çilek Formlu Seramik Tabak",
                CategoryId = categoryIds["Tabak"],
                Price = 460,
                Image = "assets/products/tabak_03.png",
                Description = "Çilek detaylarıyla renkli ve eğlenceli seramik tabak.",
                Stock = 4
            },

            new Product
            {
                Name = "Pembe Detaylı Seramik Tabak",
                CategoryId = categoryIds["Tabak"],
                Price = 430,
                Image = "assets/products/tabak_04.png",
                Description = "Pembe detaylarıyla sade ve romantik tasarımlı seramik tabak.",
                Stock = 7
            },

            new Product
            {
                Name = "Çiçek Detaylı Seramik Tabak",
                CategoryId = categoryIds["Tabak"],
                Price = 440,
                Image = "assets/products/tabak_05.png",
                Description = "Çiçek detaylarıyla tasarlanmış zarif el yapımı seramik tabak.",
                Stock = 6
            },

            // ========================================================
            // KASELER
            // ========================================================

            new Product
            {
                Name = "Çiçek Desenli Seramik Kase",
                CategoryId = categoryIds["Kase"],
                Price = 480,
                Image = "assets/products/kase_01.png",
                Description = "Çiçek desenleriyle süslenmiş el yapımı seramik kase.",
                Stock = 5
            },

            new Product
            {
                Name = "Dekoratif Seramik Kase",
                CategoryId = categoryIds["Kase"],
                Price = 460,
                Image = "assets/products/kase_02.png",
                Description = "Yumuşak renkleri ve özgün formuyla dekoratif seramik kase.",
                Stock = 7
            },

            new Product
            {
                Name = "Çiçek Formlu Seramik Kase",
                CategoryId = categoryIds["Kase"],
                Price = 490,
                Image = "assets/products/kase_03.png",
                Description = "Çiçek formundan ilham alan dekoratif ve kullanışlı seramik kase.",
                Stock = 5
            },

            new Product
            {
                Name = "Lacivert Seramik Kase",
                CategoryId = categoryIds["Kase"],
                Price = 520,
                Image = "assets/products/kase_04.png",
                Description = "Lacivert tonlarıyla dikkat çeken özgün el yapımı seramik kase.",
                Stock = 4
            },

            // ========================================================
            // ANAHTARLIKLAR
            // ========================================================

            new Product
            {
                Name = "Mavi Boncuklu Seramik Anahtarlık",
                CategoryId = categoryIds["Anahtarlık"],
                Price = 240,
                Image = "assets/products/anahtarlik_01.png",
                Description = "Renkli seramik boncuk detaylarıyla el yapımı anahtarlık.",
                Stock = 10
            },

            new Product
            {
                Name = "Çiçekli Seramik Anahtarlık",
                CategoryId = categoryIds["Anahtarlık"],
                Price = 250,
                Image = "assets/products/anahtarlik_02.png",
                Description = "Çiçek detaylarıyla hazırlanmış zarif seramik anahtarlık.",
                Stock = 8
            },

            new Product
            {
                Name = "Pastel Seramik Anahtarlık",
                CategoryId = categoryIds["Anahtarlık"],
                Price = 260,
                Image = "assets/products/anahtarlik_03.png",
                Description = "Pastel renkli seramik parçalarla tasarlanmış anahtarlık.",
                Stock = 7
            },

            new Product
            {
                Name = "Renkli Seramik Anahtarlık",
                CategoryId = categoryIds["Anahtarlık"],
                Price = 270,
                Image = "assets/products/anahtarlik_04.png",
                Description = "Renkli ve eğlenceli tasarımıyla özgün seramik anahtarlık.",
                Stock = 6
            },

            new Product
            {
                Name = "Çiçek Figürlü Anahtarlık",
                CategoryId = categoryIds["Anahtarlık"],
                Price = 255,
                Image = "assets/products/anahtarlik_05.png",
                Description = "Çiçek figürleriyle süslenmiş el yapımı seramik anahtarlık.",
                Stock = 8
            },

            // ========================================================
            // KİTAP AYRAÇLARI
            // ========================================================

            new Product
            {
                Name = "Minimal Seramik Kitap Ayracı",
                CategoryId = categoryIds["Kitap Ayracı"],
                Price = 280,
                Image = "assets/products/ayrac_01.png",
                Description = "Sade tasarımıyla kitaplarınıza eşlik edecek seramik kitap ayracı.",
                Stock = 10
            },

            new Product
            {
                Name = "Çiçek Detaylı Kitap Ayracı",
                CategoryId = categoryIds["Kitap Ayracı"],
                Price = 290,
                Image = "assets/products/ayrac_02.png",
                Description = "Çiçek detaylarıyla el yapımı seramik kitap ayracı.",
                Stock = 8
            },

            new Product
            {
                Name = "Çiçek Desenli Kitap Ayracı",
                CategoryId = categoryIds["Kitap Ayracı"],
                Price = 300,
                Image = "assets/products/ayrac_03.png",
                Description = "Özgün çiçek deseniyle tasarlanmış dekoratif seramik kitap ayracı.",
                Stock = 7
            },

            // ========================================================
            // BİBLO
            // ========================================================

            new Product
            {
                Name = "Çiçek Figürlü Seramik Biblo",
                CategoryId = categoryIds["Biblo"],
                Price = 590,
                Image = "assets/products/biblo_01.png",
                Description = "Dekorasyonunuza sıcaklık katacak el yapımı seramik biblo.",
                Stock = 4
            },

            // ========================================================
            // TABLOLAR
            // ========================================================

            new Product
            {
                Name = "Çiçekli Seramik Tablo",
                CategoryId = categoryIds["Tablo"],
                Price = 890,
                Image = "assets/products/tablo_01.png",
                Description = "El yapımı, çiçek detaylarıyla tasarlanmış özgün seramik tablo.",
                Stock = 5
            },

            new Product
            {
                Name = "Dekoratif Seramik Tablo",
                CategoryId = categoryIds["Tablo"],
                Price = 950,
                Image = "assets/products/tablo_02.png",
                Description = "Duvar dekorasyonuna zarif bir dokunuş sağlayan el yapımı seramik tablo.",
                Stock = 3
            },

            // ========================================================
            // VAZOLAR
            // ========================================================

            new Product
            {
                Name = "Çiçekli Seramik Vazo",
                CategoryId = categoryIds["Vazo"],
                Price = 780,
                Image = "assets/products/vazo_01.png",
                Description = "Çiçeklerle birlikte kullanıma uygun, dekoratif el yapımı seramik vazo.",
                Stock = 4
            },

            new Product
            {
                Name = "Minimal Seramik Vazo",
                CategoryId = categoryIds["Vazo"],
                Price = 720,
                Image = "assets/products/vazo_02.png",
                Description = "Sade ve doğal görünümüyle her dekorasyona uyum sağlayan seramik vazo.",
                Stock = 5
            },

            new Product
            {
                Name = "Renkli Çiçekli Seramik Vazo",
                CategoryId = categoryIds["Vazo"],
                Price = 820,
                Image = "assets/products/vazo_03.png",
                Description = "Renkli çiçek detaylarıyla dikkat çeken özgün seramik vazo.",
                Stock = 3
            },

            new Product
            {
                Name = "Pembe Kurdeleli Seramik Vazo",
                CategoryId = categoryIds["Vazo"],
                Price = 850,
                Image = "assets/products/vazo_04.png",
                Description = "Zarif pembe kurdele detayıyla tasarlanmış dekoratif seramik vazo.",
                Stock = 4
            }
        };

        context.Products.AddRange(products);
        context.SaveChanges();
    }
}