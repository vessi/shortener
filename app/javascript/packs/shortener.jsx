import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import MuiThemeProvider from '@material-ui/core/styles/MuiThemeProvider'
import createMuiTheme from '@material-ui/core/styles/createMuiTheme'
import { orange, deepOrange } from '@material-ui/core/colors'

import Main from './pages/Main'

const theme = createMuiTheme({
  palette: {
    primary: {
      main: orange[500]
    },
    secondary: {
      main: deepOrange[500]
    }
  },
  typography: {
    useNextVariants: true,
    fontFamily: [
      '"Lato"',
      'sans-serif'
    ].join(',')
  }
})

const App = () => (
  <MuiThemeProvider theme={theme}>
    <Main />
  </MuiThemeProvider>
)

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.body.appendChild(document.createElement('div')),
  )
})
