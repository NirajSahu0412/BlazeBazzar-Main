import 'package:blazebazzar/buyers/views/product_deatil/product_detail_screen.dart';
import 'package:blazebazzar/config/app_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        return Container(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailScreen(productData: productData,);
                      },
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 180,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                              NetworkImage(productData['imageUrlList'][0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        productData['productName'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "₹ " + productData['productPrice'].toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 20,
                            color: FlexColor.mandyRedLightPrimary
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, _) => Gap(15),
            itemCount: snapshot.data!.docs.length,
          ),
        );
      },
    );
  }
}