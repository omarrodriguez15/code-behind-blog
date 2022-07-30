# Code behind for blog  
This repo is used to generate the static website content for my [live site.](https://github.com/omarrodriguez15/omarrodriguez15.github.io) The site is generated using jekyll and forked from [here](https://github.com/renyuanz/leonids/)

# Quick start
[Install Jekyll here](https://jekyllrb.com/docs/installation/)

For local testing : `bundle exec jekyll server`

Generate site for production : `bundle exec jekyll build`
* This is automated for the most part by opening a PR in this repo. The PR will run the proper commands and open a PR in the live website repo to update the content with latest generated content.
* Copy over the _site folder to the [omarrodriguez15.github.io repo.](https://github.com/omarrodriguez15/omarrodriguez15.github.io)
   * exclude files like README.md

# Other  
On windows I used Ubuntu on WSL to install jekyll its much simpler than dealing with all the ruby installer nonsense on windows directly. Then in ubuntu you can navigate to windows folder directory by navigating to the mounted c drive `cd /mnt/c/code/code-behind-blog/` and running commands there and still use vs code and your browser in windows.
