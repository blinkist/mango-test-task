👋 Hi there!

To get a better understanding of your work and thinking process, we’ve put together a problem we’d like you to solve.

We would like you to act as the SRE in helping the development team and prepare a small one page document explaining your recommendations and any other questions you’d have to the development team on getting the application prepared for production.

The document should cover the following topics:

1. What is required for the application to be production ready?
2. Is there anything else to make local development easier?
2. What else would you change?

The document will be used in the next stage of the interview process. We would have an open discussion lasting 30 minutes to discuss your recommendations. We’d ask questions about the recommendations, how you might implement any changes, and also discuss any past experiences you’ve had making improvements.

## Tech details

Imagine that the application is currently running in a development environment.

Our production setup looks like this:

1. We currently run on AWS ECS Fargate, proxied via an Application Load Balancer and Cloudflare as the CDN. 
2. We use Terraform (with Atlantis) to manage our infrastructure.
3. Fluentbit processes the application's logs and forward them to DataDog.

## Application description

It is a blog post that have 4 endpoints:

1. List posts
2. Create a post
3. Show a post
4. Update a post
5. Delete a post

All endpoints require basic authorisation and credentials are user's email and password.

## Setup instructions

1. Run `./batect setup` to install gems and run database migrations.
2. Run `./batect server` to start Rails server.
3. Run `./batect shell` to run shell.

The seeds will prepare posts and create 2 users

1. Normal user: user@blinkist, password `password`
2. Anonymous user (in the app, we have a randomly generated "anonymous user" to interact with some parts of the API): anonymous@blinkist, password: `password`

## Examples of requests

### List posts
```
curl -u "user@blinkist:password" http://localhost:3000/api/posts
```

### Create posts
```
curl -u "user@blinkist:password" -H 'Content-Type: application/json' \
-d '{"name": "post", "content": "content"}' \
--request POST 'http://localhost:3000/api/posts'
```

### Update a post

```
curl -u "user@blinkist:password" -H 'Content-Type: application/json' \
-d '{"name": "new name", "content": "new content"}' \
--request PUT 'http://localhost:3000/api/posts/2001'
```

### Show a post

#### By Anonymous user

```
curl -u "anonymous@blinkist:password" http://localhost:3000/api/posts/5100
```

#### Try request a post that is blocked

```
curl -u "anonymous@blinkist:password" http://localhost:3000/api/posts/900
```

### Delete a post

#### By Anonymous user with iOS device

```
curl -u "anonymous@blinkist:password" --request DELETE 'http://localhost:3000/api/posts/5010' \
-H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 16_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Mobile/15E148 Safari/604.1'
```

#### By Anonymous user with Android device

```
curl -u "anonymous@blinkist:password" --request DELETE 'http://localhost:3000/api/posts/5212' \
-H 'User-Agent: Mozilla/5.0 (Android 13; Mobile; rv:68.0) Gecko/68.0 Firefox/110.0'
```

#### By Anonymous user with non mobile device

```
curl -u "anonymous@blinkist:password" --request DELETE 'http://localhost:3000/api/posts/5012'
```
