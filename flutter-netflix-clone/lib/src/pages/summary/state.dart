part of netflix;

class SummaryState extends State<Summary> {
  void goTo(String type) {
    Application.router.navigateTo(
      context,
      '${Routes.filter}',
      transition: TransitionType.nativeModal,
      transitionDuration: const Duration(milliseconds: 200),
      object: {'type': type},
    );
  }

  void goToDetail(Result item, int match) {
    Application.router.navigateTo(
      context,
      '${Routes.detail}',
      transition: TransitionType.inFromRight,
      transitionDuration: const Duration(milliseconds: 200),
      object: {'match': match, 'show': item},
    );
  }

    void goToGenre(String item) {
      if(item.split(" ").length > 0){
        item = item.replaceAll(" ", "_");
      }
    Application.router.navigateTo(
      context,
      '${Routes.genre}',
      transition: TransitionType.inFromRight,
      transitionDuration: const Duration(milliseconds: 200),
      object: {'item': item},
    );
  }

  void showMovie(String link) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]).then((e) {
      Application.router.navigateTo(
        context,
        Routes.video,
        object: {'title': '${tvShow["name"]}', 'link': '$link'},
        transition: TransitionType.inFromBottom,
        transitionDuration: const Duration(milliseconds: 200),
      );
    });
  }

  List<Widget> renderMainGenres() {
    List<Widget> genres = List.from(tvShow['genres'].map((g) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          g["name"],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 12.0,
          ),
        ),
      );
    }).toList());
    return genres;
  }

  Widget renderTitle(String tag, String text) {
    return Hero(
      tag: tag,
      child: FlatButton(
        onPressed: () => goTo(tag),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    Result show;
    bloc.fetchAllMovies();
    
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
        if (snapshot.hasData) {
          show = Result.fromJson(tvShow);
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                primary: true,
                expandedHeight: screenSize.height * 0.65,
                backgroundColor: Colors.black,
                leading: Image.asset('assets/images/netflix_icon.png'),
                titleSpacing: 20.0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.network(pichost + show.image, fit: BoxFit.cover),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              stops: [0.1, 0.6, 1.0],
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black
                              ],
                            ),
                          ),
                          child: Container(
                            height: 40.0,
                            width: screenSize.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 3.0,
                                          color:
                                              Color.fromRGBO(185, 3, 12, 1.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tvShow['name'].replaceAll(' ', '\n'),
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        height: .9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: renderMainGenres(),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                        textColor: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              '',
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => print('Bosluq Doldurur'),
                                      ),
                                      RaisedButton(
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.play_arrow),
                                            Text(
                                              'Izle',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: ()=> showMovie(show.movieLink)
                                      ),
                                      FlatButton(
                                        textColor: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Icon(Icons.info_outline),
                                            Text(
                                              'Bilgi',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        onPressed: () => goToDetail(show, 99),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ShowsList(
                    items: snapshot.data[index].results,
                    onTap: goToDetail,
                    title: snapshot.data[index].title,
                    goToGenre: goToGenre,
                  ),
                  childCount: snapshot.data.length,
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromRGBO(219, 0, 0, 1.0)),
        ));
      },
    );
  }
}
