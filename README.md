Install elm, then:

```bash
$ elm make src/Main.elm --output elm.js
$ npm i -g serve
$ serve
```

Open http://localhost:5000

## Browser.element

`Browser.element` example from

- https://guide.elm-lang.org/architecture/
- https://package.elm-lang.org/packages/elm/browser/latest/Browser#element
- https://guide.elm-lang.org/effects/http.html

## Radio button

- https://stackoverflow.com/questions/45925255/having-radio-buttons-reflect-the-model

## title

use `Browser.document`

- https://guide.elm-lang.org/webapps/
- https://package.elm-lang.org/packages/elm/browser/latest/Browser#document

## Notification

- https://github.com/liamcurry/elm-pomodoro/blob/13580c042bbb489c04c1a4b2e6b549808ffea5b8/src/elm/Native/Notifications.js
- https://discourse.elm-lang.org/t/port-support-lets-collaborate-on-better-experiences-with-ports
- https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API/Using_the_Notifications_API
- https://developer.mozilla.org/en-US/docs/Web/API/notification

## ports, custom html and elm reactor

Because Notification is not natively supported by Elm, I needed to use ports.

Ports needs custom html, but `elm reactor` does not allow this.

So for now I have generated `index.html` with

`elm make src/Main.elm`.

Then modified `index.html` for my needs.

Then I generate `elm.js` with

`elm make src/Main.elm --output elm.js`

- https://guide.elm-lang.org/webapps/
- https://elm-lang.org/0.19.0/init
- https://discourse.elm-lang.org/t/elm-reactor-init-with-flags-for-0-19/2217/2
- https://stackoverflow.com/questions/52702961/using-custom-html-with-elm-reactor-or-another-dev-server-in-0-19
