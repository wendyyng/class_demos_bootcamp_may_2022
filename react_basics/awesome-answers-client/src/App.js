import './App.css';
import React, { Component } from 'react';
// import CurrentDateTime from './components/CurrentDateTime'
// import { Session } from './requests';
import QuestionIndexPage from './components/QuestionIndexPage';
import QuestionShowPage from './components/QuestionShowPage';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import NavBar from './components/NavBar';
import NewQuestionPage from './components/NewQuestionPage';
import { User } from './requests';
import SignInPage from './components/SignInPage';


class App extends Component {
  constructor(props){
    super(props);
    this.state = {
      // clocksCount: [1], //an array of something
      user: null
    }
  }

  componentDidMount(){
    this.getCurrentUser()
  }

  getCurrentUser = () => {
    return User.current().then(user => {

      if (user?.id){
        this.setState(state => {
          return { user }
        })
      }
    })
  }
  render(){

    return (
      <BrowserRouter>
        <NavBar currentUser={this.state.user}/>
        <Switch>
          <Route exact path='/sign_in'
          render={(routeProps) => <SignInPage {...routeProps} onSignIn={this.getCurrentUser} />}
          >
          </Route>
          <Route exact path='/questions' component={QuestionIndexPage}/>
          <Route exact path='/questions/new' component={NewQuestionPage}></Route>
          <Route exact path='/questions/:id' component={QuestionShowPage} />
        </Switch>
      </BrowserRouter>
    );
  }
}

export default App;
