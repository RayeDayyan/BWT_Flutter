import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_6_e_commerce_amazon_clone/app_bar.dart';
import 'package:task_6_e_commerce_amazon_clone/product_details.dart';
import 'package:task_6_e_commerce_amazon_clone/providers.dart';

import 'package:task_6_e_commerce_amazon_clone/bottom_nav.dart';

class CustomerHome extends ConsumerStatefulWidget{

  @override
  ConsumerState<CustomerHome> createState() => CustomerHomeState();
}

class CustomerHomeState extends ConsumerState<CustomerHome>{

  @override
  Widget build(BuildContext context){
    var productsProvider = ref.watch(getAllProductsProvider);

    return Scaffold(
      // appBar:SizedBox(height: 10,width: 10,child: TextField(),)

      appBar: CustomAppBar(),


      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(20),
          child: Text('Exclusively for YOU!',
            style: TextStyle(
                fontFamily: 'Ember',
                fontSize: 30
            )
            ,
          )

      ),


        productsProvider.when(
            data: (products){

              return Expanded(
                child: ListView.builder(
                    itemCount: products?.length,

                    itemBuilder: (context,index){
                      final product = products?[index];
                      String? image = product?.image;
                      final imageUrl = 'http://10.0.2.2:3000/uploads/${product?.image}';

                      return Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.black,
                                      width: 1
                                  )
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),

                          child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child:ListTile(

                                onTap: () {
                                  ref.read(productProvider.state).state= product;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails()));
                                },
                                  leading: image!=null ?
                                  Container(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(imageUrl,)


                                  )
                                      : Container(
                                    height: 80,
                                    width: 80,
                                    child: Text('no image'),
                                  ),
                                  title: Text(
                                  '${product?.Name}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Ember'
                                  ),
                                ),

                                subtitle: Text(
                                  '${product?.Description}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Ember'
                                  ),



                                ),

                                trailing:Text('Price: ${product?.Price} only',
                                style: TextStyle(
                                  fontFamily: 'Ember',
                                  fontSize: 15
                                ),

                                )



                              )


                          )



                      );


                    })
                ,
              );


            },
            error: (error,stackTree){
              return Text("Error occured while fetching data");
            },
            loading: (){
              return CircularProgressIndicator();
            })





        ]
      ),







      bottomNavigationBar: BottomNav()

    );
  }

}