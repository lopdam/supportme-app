import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Services/ratings_service.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';

class RatingBarIndicator extends StatefulWidget {
  int _hueca;

  RatingBarIndicator(this._hueca);

  @override
  _RatingBarIndicator createState() {
    return _RatingBarIndicator(_hueca);
  }
}

class _RatingBarIndicator extends State<RatingBarIndicator> {
  int _hueca;

  _RatingBarIndicator(this._hueca);
  double _ratingMedian;
  double _rating;
  int tmpRating;
  @override
  void initState() {
    super.initState();
    _rating = 0;
    tmpRating = 0;
    _ratingMedian = 0;

    RatingsService.get_rating(hueca: _hueca)
        .then((score) => _loadRating(score));

    //Calcular el Promedio de Ratings
    RatingsService.get_ratings(hueca: _hueca)
        .then((MedianScores) => _loadRatings(MedianScores));
  }

  @override
  Widget build(BuildContext context) {
    return _ratingContainer();
  }

  Widget _ratingContainer() {
    return Card(
      elevation: 0,
      child: Row(
        children: [
          _ratingHueca(),
          _ratingNumber(),
        ],
      ),
    );
  }

  Widget _ratingNumber() {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 6),
      child: Text(
        (_ratingMedian != 0) ? _ratingMedian.toString() : "0",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        maxLines: 1,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.mainColor),
      ),
    );
  }

  Widget _ratingHueca() {
    return RatingBar(
      initialRating: _rating,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      unratedColor: Colors.grey,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) => _startRate(context, index),
      onRatingUpdate: (rating) {
        if (!AccountSave.isLogin()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ),
          );
        } else {
          tmpRating = rating.toInt();
          if (_rating == 0) {
            _to_rate_hueca();
          } else {
            update_rate();
          }
        }
      },
    );
  }

  Icon _startRate(BuildContext context, int index) {
    if (AccountSave.isLogin()) {
      return Icon(
        Icons.star,
        color: Colors.amber,
      );
    } else {
      return Icon(
        Icons.star,
        color: Colors.grey,
      );
    }
  }

  void _loadRating(int score) async {
    _rating = score.toDouble();
    setState(() {});
  }

  //Median Users Rating
  void _loadRatings(double score) async {
    _ratingMedian = score;
    setState(() {});
  }

  //Post Rating
  void _to_rate_hueca() async {
    bool temporal;
    await RatingsService.post_rating(hueca: _hueca, score: tmpRating)
        .then((value) => temporal = value);
    if (temporal) {
      print("Temporal: " + tmpRating.toString());
    }
    RatingsService.get_ratings(hueca: _hueca)
        .then((MedianScores) => _loadRatings(MedianScores));
    setState(() {});
  }

  //Post Rating
  void update_rate() async {
    bool temporal;
    await RatingsService.update_rating(hueca: _hueca, score: tmpRating)
        .then((value) => temporal = value);
    RatingsService.get_ratings(hueca: _hueca)
        .then((MedianScores) => _loadRatings(MedianScores));
    if (temporal) {
      print("Temporal: " + tmpRating.toString());
    }

    setState(() {});
  }
}
