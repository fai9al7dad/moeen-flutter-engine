# moeen

## bugs

- [ ] words on right column cant be highlighted -> quran screen
- [ ] on highlight word, first show new color with state, then refresh
- [ ] need to add remaining fonts

## improvments

- [ ] optimize sql init query on android, ios->?
- [ ] switch text spans to Word widget?
- [ ] add border bottom to button
- [ ] switch warning to svg -> select duo
- [ ] show empty state -> duo
- [ ] update empty state -> werd
- [ ] update empty state -> invites
- [ ] switch fab to custom button?
- [ ] optimize page header
  - [ ] last where or null -> make query on backend ?
  - [ ] state on init not on builder
- [ ] show animation on highlight -> [warning,mistake]
- [ ] padding on view werd highlights list
- [ ] start from last stopped page
- [ ] surah list init index is which current chapter im in

## current iteration

- [x] sync
  - [x] create tempWCM
  - [x] on add mistake, if not auth add to temp
  - [x] on login, check if temp is not empty
    - [x] if not show alert
      - [x] on accept sync from temp to backend
        - [x] clear temp
      - [x] on reject clear temp
  - [x] on settings page
    - [x] show sync account
      - [x] sync from backend to sqlite
- [x] settings
  - [x] add setting icon
  - [x] user info -> if auth
  - [x] about app
  - [x] send report -> need physical device testing
  - [x] send suggestion -> need physical device testing
  - [x] sync from backend to sqlite
  - [x] log out

## finished

- [x] word highlight = black->warning->mistake->revert
- [x] page header
  - [x] add juz number
  - [x] add hizb number
  - [x] page number
  - [x] show page mistakes and warnings
    - [x] click to open modal to go to page
  - [x] add page header
  - [x] surah name
    - [x] click to open surah list screen
    - [x] surah name
    - [x] surah page from to
    - [x] mistakes and warning
    - [x] pagescount
    - [ ] type ... low pri
    - [x] verses count
    - [x] click go to first page
- [ ] auth
  - [x] login
  - [x] register
  - [ ] forgot password
  - [x] local storage auth
- [x] duos
  - [x] show need to login if not auth
  - [x] view duos
  - [x] view duos invites
  - [x] accept duo invite
  - [x] reject duo invite
  - [x] send duo invites
- [x] werd
  - [x] get werd
  - [x] add werds
    - [x] send api
    - [x] set global isWerd true, duoid, werd id, reciter username
- [x] werd highlights
  - [x] change local mw to reciter mw
  - [x] change grean duo header to red werd header
  - [x] add highlight by werd id
  - [x] view werd highlights and mistakes
  - [x] finish werd
  - [x] return to local mw
  - [x] view werd highlights
  - [x] accept highlights
    - [x] dont show accept if not reciter
- [x] sync
  - [x] create tempWCM
  - [x] on add mistake, if not auth add to temp
  - [x] on login, check if temp is not empty
    - [x] if not show alert
      - [x] on accept sync from temp to backend
        - [x] clear temp
      - [x] on reject clear temp
  - [x] on settings page
    - [x] show sync account
      - [x] sync from backend to sqlite
- [x] settings
  - [x] add setting icon
  - [x] user info -> if auth
  - [x] about app
  - [x] send report -> need physical device testing
  - [x] send suggestion -> need physical device testing
  - [x] sync from backend to sqlite
  - [x] log out
