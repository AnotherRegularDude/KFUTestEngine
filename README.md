# README

## KFU Testing Engine as homework

This service is divided into two parts: backend (just api with small help of JWE) and
frontend (just single page application). I think, JWE is most suited for replacement of browser cookies.
It is just encrypted payload, which store some sensitive user information (for example, *user_id*).
And only server can decrypt and read this data (encryption via AES and RSA).
So, I think, this solution is very secure and, on the other side, is very easy to use.

### Backend

1. Rails 5.1 will be used;
2. JSON API designed just in code, also, [this](http://jsonapi.org/) specification sucks=);
3. PostgreSQL as database, **of course**;
4. ???
5. **PROFIT**

### Schema structure

![Schema structure picture](https://github.com/VanyaZ158/KFUTestEngine/raw/master/shema.png)
