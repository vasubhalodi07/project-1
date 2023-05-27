import 'package:flutter/material.dart';
import 'package:news_app/screens/category_view.dart';

class NewsCategory extends StatefulWidget {
  const NewsCategory({Key? key}) : super(key: key);

  @override
  State<NewsCategory> createState() => _NewsCategoryState();
}

class _NewsCategoryState extends State<NewsCategory> {

  List<dynamic> _category = [
    Category(color: Color(0xFF1bbca3), icon: 'assets/images/fashion.png', title: 'Fashion', shadeColor: Color(0xFF6ad6c6), key: 'fashion'),
    Category(color: Color(0xFF3e86ed), icon: 'assets/images/sport.png', title: 'Sport', shadeColor: Color(0xFF9bbef4), key: 'sport'),
    Category(color: Color(0xFF804bdb), icon: 'assets/images/education.png', title: 'Education', shadeColor: Color(0xFFbca1f2), key: 'education'),
    Category(color: Color(0xFFe84eb1), icon: 'assets/images/entertainment.png', title: 'Entertainment', shadeColor: Color(0xFFf89fd7), key: 'entertainment'),
    Category(color: Color(0xFF28adc5), icon: 'assets/images/current-affaris.png', title: 'Current Affairs', shadeColor: Color(0xFF8ec6d3), key: 'current-affairs'),
    Category(color: Color(0xFFd4bb2a), icon: 'assets/images/trade.png', title: 'Finance', shadeColor: Color(0xFFf4e168), key: 'trade'),
    Category(color: Color(0xFF7dab78), icon: 'assets/images/technology.png', title: 'Technology', shadeColor: Color(0xFFa0d69a), key: 'technology'),
    Category(color: Color(0xFF8a6c65), icon: 'assets/images/electornics.png', title: 'Electronics', shadeColor: Color(0xFFb58c81), key: 'electronics'),
    Category(color: Color(0xFFb5646c), icon: 'assets/images/health.png', title: 'Health', shadeColor: Color(0xFFd47982), key: 'health'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.065, right: width * 0.065, top: height * 0.01),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 30, color: Color.fromRGBO(0, 21, 214, 1)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.category,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),

              SizedBox(
                height: height * 0.01,
              ),

              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: _category.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _category[index].shadeColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryView(key_api :_category[index].key, title_api : _category[index].title),),);
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                                width: width * 0.18,
                                height: height * 0.08,
                                decoration: BoxDecoration(
                                  color: _category[index].color,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Opacity(
                                    opacity: 0.9,
                                    child: Image.asset(
                                      '${_category[index].icon}',
                                      width: 39,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.01,),

                              Text(
                                '${_category[index].title}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  var color, icon, title, shadeColor, key;
  Category({required this.color, required this.icon, required this.title, required this.shadeColor, required this.key});
}
