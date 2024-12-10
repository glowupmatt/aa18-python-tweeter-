from flask import render_template, redirect, url_for
from app import app
from .tweets import tweets
from .form import TweetForm
import random

@app.route("/")
def index():
    tweet_keys = list(tweets.keys())
    random_index = random.randint(0, len(tweet_keys) - 1)
    tweet_id = tweet_keys[random_index]
    tweet = tweets[tweet_id]
    return render_template('index.html', tweet=tweet)

@app.route("/post/<int:id>")
def selectedPost(id):
    tweet = tweets.get(id)
    return render_template('index.html', tweet=tweet)

@app.route("/feed")
def feed():
    return render_template('feed.html', tweets=tweets)


@app.route("/new", methods=['GET', 'POST'])
def new_tweet():
    form = TweetForm()
    if form.validate_on_submit():
        new_id = max(tweets.keys()) + 1
        tweets[new_id] = {
            "author": form.author.data,
            "date": "today", 
            "tweet": form.tweet.data,
            "likes": 0
        }
        return redirect(url_for('selectedPost', id=new_id))
    return render_template('form.html', form=form)