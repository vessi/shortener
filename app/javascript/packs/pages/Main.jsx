import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import withStyles from '@material-ui/core/styles/withStyles'
import LinkIcon from '@material-ui/icons/Link'
import { CssBaseline, Avatar, Paper, Typography, FormControl, InputLabel, Input, Button } from '@material-ui/core';
import styles from './styles/Main'

const Main = ({ classes }) => {
  const [url, setUrl] = useState('')
  const handleSubmit = async (event) => {
    event.preventDefault()
    const response = await fetch('/', {
      method: 'POST',
      body: JSON.stringify({ url }),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    });
    const data = await response.json()
    setUrl(data.short_url)
  }
  const handleChange = (event) => {
    event.persist()
    setUrl(event.target.value)
  }

  return (
    <main className={classes.main}>
      <CssBaseline />
      <Paper className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LinkIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          Shorten link
        </Typography>
        <form className={classes.form} onSubmit={handleSubmit}>
          <FormControl margin="normal" required fullWidth>
            <InputLabel htmlFor="url">URL:</InputLabel>
            <Input
              id="url"
              name="url"
              autoFocus
              onChange={handleChange} value={url}
            />
          </FormControl>
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit}
          >
            Shorten
          </Button>
        </form>
      </Paper>
    </main>
  )
}

Main.propTypes = {
  classes: PropTypes.object.isRequired,
}

export default withStyles(styles)(Main)
