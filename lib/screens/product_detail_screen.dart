import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/favorite_service.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();

    isFavorite =
        FavoriteService.isFavorite(widget.product);
  }

  void toggleFavorite() {
    setState(() {
      FavoriteService.toggleFavorite(
        widget.product,
      );

      isFavorite =
          FavoriteService.isFavorite(
        widget.product,
      );
    });
  }

  void addToCart() {
    final product = widget.product;

    if (product.stock <= 0) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Bu ürün şu anda stokta yok.',
          ),
          duration:
              Duration(seconds: 2),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );

      return;
    }

    final currentQuantity =
        CartService.quantity(product);

    if (currentQuantity >= product.stock) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar();

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Stoktaki maksimum ürün adedine ulaştınız.',
          ),
          duration:
              Duration(seconds: 2),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );

      return;
    }

    CartService.add(product);

    setState(() {});

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 19,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${product.name} sepete eklendi.',
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        duration:
            const Duration(seconds: 3),

        showCloseIcon: true,

        closeIconColor:
            Colors.white,

        action: SnackBarAction(
          label: 'Sepete Git',
          textColor:
              const Color(0xFFF3DCCB),

          onPressed: () {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CartScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  String get storyTitle {
    final name =
        widget.product.name.toLowerCase();

    if (name.contains('penelope')) {
      return 'Penelope • Sabır ve Bekleyiş';
    }

    if (name.contains('athena')) {
      return 'Athena • Bilgelik ve Güç';
    }

    if (name.contains('ariadne')) {
      return 'Ariadne • Yolunu Bulmak';
    }

    switch (widget.product.category) {
      case 'Kupa':
        return 'Günlük Ritüellerin Hikâyesi';

      case 'Tabak':
        return 'Sofranın Küçük Hikâyesi';

      case 'Kase':
        return 'Toprağın Sessiz Hikâyesi';

      case 'Anahtarlık':
        return 'Yanında Taşıdığın Küçük Hikâye';

      case 'Kitap Ayracı':
        return 'Sayfalar Arasında Bir İz';

      case 'Biblo':
        return 'Evin Küçük Karakteri';

      case 'Tablo':
        return 'Duvarlarda Bir An';

      case 'Vazo':
        return 'Çiçeklerin Evi';

      default:
        return 'ICY Ceramic Hikâyesi';
    }
  }

  String get storyText {
    final name =
        widget.product.name.toLowerCase();

    if (name.contains('penelope')) {
      return 'Penelope, zamanın karşısında sabrı seçen bir figürdür. '
          'Bu parça da acele etmeden beklemenin, sevdiğin şeylere '
          'sadık kalmanın ve kendi hikâyenin doğru zamanını beklemenin '
          'küçük bir hatırlatıcısı olarak tasarlandı.';
    }

    if (name.contains('athena')) {
      return 'Athena, bilgelik, strateji ve güçlü kararlarla özdeşleşir. '
          'Bu tasarım onun sakin ama kararlı karakterinden ilham alır. '
          'Bazen en güçlü hareketin, doğru zamanı beklemek olduğunu hatırlatır.';
    }

    if (name.contains('ariadne')) {
      return 'Ariadne, karmaşık labirentte yolunu bulmaya yardım eden ipliğiyle '
          'hatırlanır. Bu parça da hayat ne kadar karmaşık görünürse görünsün '
          'insanın kendisine ait yolu bulabileceğini anlatır.';
    }

    switch (widget.product.category) {
      case 'Kupa':
        return 'Bir seramik kupa yalnızca bir içecek kabı değildir. '
            'Sabahın ilk kahvesine, uzun bir çalışma gecesine veya '
            'sessiz bir akşam molasına eşlik eden küçük bir ritüeldir. '
            'Bu tasarım, günlük anları daha özel hissettirmek için hazırlandı.';

      case 'Tabak':
        return 'Tabaklar, sofranın yalnızca bir parçası değil; '
            'paylaşılan anların sessiz eşlikçileridir. Bu tasarım, '
            'el yapımı seramiğin doğal dokusunu günlük yaşamın sıcaklığıyla '
            'bir araya getirmek için oluşturuldu.';

      case 'Kase':
        return 'Kase formu, toprağın kendisinden gelen sade ve doğal '
            'bir hissi taşır. Bu parça; küçük objelerden atıştırmalıklara '
            'kadar günlük hayatın farklı anlarında kullanılabilecek '
            'sıcak ve özgün bir seramik olarak tasarlandı.';

      case 'Anahtarlık':
        return 'Bazen en küçük objeler en kişisel olanlardır. '
            'Bu seramik anahtarlık, her gün yanında taşıdığın eşyalara '
            'küçük ve el yapımı bir dokunuş katmak için tasarlandı.';

      case 'Kitap Ayracı':
        return 'Bir kitap ayracı yalnızca kaldığın sayfayı göstermez. '
            'Okuduğun hikâyeyle aranda küçük bir bağ kurar. '
            'Bu tasarım, kitapların arasında kaybolan o sakin anlara '
            'eşlik etmek için hazırlandı.';

      case 'Biblo':
        return 'El yapımı bir biblo, bulunduğu mekâna yalnızca görüntü değil, '
            'bir karakter de kazandırır. Bu parça, evinde küçük ama '
            'kendine özgü bir hikâye oluşturması için tasarlandı.';

      case 'Tablo':
        return 'Seramik yüzey üzerine aktarılan her detay, ışığa ve mekâna '
            'farklı bir şekilde karşılık verir. Bu eser, duvarında '
            'sade ama karakter sahibi bir iz bırakmak için tasarlandı.';

      case 'Vazo':
        return 'Vazo, çiçekleri taşımaktan çok daha fazlasını yapabilir. '
            'Boşken bile bir mekânın parçasıdır. Bu tasarım, doğal formları '
            've seramiğin sıcaklığını bir araya getirmek için hazırlandı.';

      default:
        return 'ICY Ceramic ürünleri, el yapımı seramiğin doğal karakterini '
            'günlük yaşamın içine taşımak için tasarlanır. Her parça, '
            'kendine özgü küçük bir hikâyeye sahip olacak şekilde düşünülür.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final cartQuantity =
        CartService.quantity(product);

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F4EE),

      body: SafeArea(
        child: CustomScrollView(
          physics:
              const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor:
                  const Color(0xFFF7F4EE),
              elevation: 0,
              pinned: true,

              leading: Padding(
                padding:
                    const EdgeInsets.only(
                  left: 8,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color:
                        Color(0xFF66564E),
                    size: 19,
                  ),
                ),
              ),

              actions: [
                Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 8,
                  ),
                  child: IconButton(
                    onPressed:
                        toggleFavorite,
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite
                          ? const Color(
                              0xFFA9826E,
                            )
                          : const Color(
                              0xFF66564E,
                            ),
                      size: 23,
                    ),
                  ),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      0,
                    ),
                    child: Container(
                      height: 340,
                      width: double.infinity,
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFFBF9F5,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        border: Border.all(
                          color:
                              const Color(
                            0xFFE5DED4,
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        child: Image.asset(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color:
                                  const Color(
                                0xFFF1ECE4,
                              ),
                              child:
                                  const Center(
                                child: Icon(
                                  Icons
                                      .image_not_supported_outlined,
                                  color:
                                      Color(
                                    0xFFB0A69E,
                                  ),
                                  size: 42,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category
                              .toUpperCase(),
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF9B9189),
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          product.name,
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF383431),
                            fontSize: 25,
                            height: 1.2,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          '₺${product.price.toStringAsFixed(0)}',
                          style:
                              const TextStyle(
                            color:
                                Color(0xFFA9826E),
                            fontSize: 21,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFEFE5DC,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    product.stock >
                                            0
                                        ? Icons
                                            .check_circle_outline
                                        : Icons
                                            .remove_circle_outline,
                                    size: 15,
                                    color:
                                        const Color(
                                      0xFF8B7062,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    product.stock >
                                            0
                                        ? 'Stokta ${product.stock} adet'
                                        : 'Stokta yok',
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFF796C64,
                                      ),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        if (cartQuantity > 0) ...[
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Sepetinde $cartQuantity adet var.',
                            style:
                                const TextStyle(
                              color:
                                  Color(0xFF9B9189),
                              fontSize: 11,
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 28,
                        ),

                        const Text(
                          'Ürün Hakkında',
                          style:
                              TextStyle(
                            color:
                                Color(0xFF383431),
                            fontSize: 17,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          product.description,
                          style:
                              const TextStyle(
                            color:
                                Color(0xFF796C64),
                            fontSize: 13,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets
                                  .all(20),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFF1E9E1,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                            border: Border.all(
                              color:
                                  const Color(
                                0xFFE4D8CC,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          Color(
                                        0xFFC9A995,
                                      ),
                                      shape:
                                          BoxShape
                                              .circle,
                                    ),
                                    child:
                                        const Icon(
                                      Icons
                                          .auto_stories_outlined,
                                      color:
                                          Colors.white,
                                      size: 18,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Expanded(
                                    child: Text(
                                      storyTitle,
                                      style:
                                          const TextStyle(
                                        color:
                                            Color(
                                          0xFF66564E,
                                        ),
                                        fontSize:
                                            14,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 16,
                              ),

                              Text(
                                storyText,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFF796C64,
                                  ),
                                  fontSize: 12,
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 54,
                          child:
                              ElevatedButton(
                            onPressed:
                                product.stock > 0
                                    ? addToCart
                                    : null,
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFFC9A995,
                              ),
                              disabledBackgroundColor:
                                  const Color(
                                0xFFD8D0C9,
                              ),
                              foregroundColor:
                                  Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                const Icon(
                                  Icons
                                      .shopping_bag_outlined,
                                  size: 19,
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Text(
                                  product.stock >
                                          0
                                      ? 'Sepete Ekle'
                                      : 'Stokta Yok',
                                  style:
                                      const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
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