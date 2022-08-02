# moeen

## bugs

- [ ] words on right column cant be highlighted -> quran screen
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
- [ ] on highlight word, first show new color with state, then refresh
- [ ] optimize page header
  - [ ] last where or null
  - [ ] state on init not on builder
- [ ] show animation on highlight -> [warning,mistake]

## current iteration

- [ ] sync
  - [ ] create tempWCM
  - [ ] on add mistake, if not auth add to temp
  - [ ] on login, check if temp is not empty
    - [ ] if not show alert
      - [ ] on accept sync from temp to backend
        - [ ] clear temp
      - [ ] on reject clear temp
  - [ ] on settings page
    - [ ] show sync account
      - [ ] sync from backend to sqlite

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
