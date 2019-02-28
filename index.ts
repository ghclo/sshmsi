import { ServiceConstructor, ServiceLoader } from 'ligature';
import 'reflect-metadata';
/*import ClientRoute from './routes/clients';
import PDFRoute from './routes/pdfs';
import ClientRuleRoute from './routes/rules';
import SessionsRoute from './routes/sessions';
import TransfereeRoute from './routes/transferees';
import Bridge from './services/bridge';
import Express from './services/express';
import Logger from './services/logger';

import ServiceBus from './services/servicebus';
import Session from './services/session';
import SocketIO from './services/socketio';
*/
import MongoDB from './mongodb';

let services: ServiceConstructor[] = [
  MongoDB
  /*Logger,
  
  Express,
 
  
  Session,
  ServiceBus,
  SocketIO,
  Bridge */
];

//const routes = [ClientRoute, TransfereeRoute, ClientRuleRoute, PDFRoute, SessionsRoute];

//services = [...services, ...routes];

services = [...services];
ServiceLoader.getInstance()
  .init(services)
  .then(
    () => {
      console.log('started!');
     
      /*const { APP_INSIGHTS_INSTRUMENTATION_KEY = '' } = process.env;
      if (APP_INSIGHTS_INSTRUMENTATION_KEY !== '') {
        const appInsights = require('applicationinsights');
        appInsights.setup(APP_INSIGHTS_INSTRUMENTATION_KEY).start();
      }*/
    },
    err => {
      console.log('Could not start server', err);
      process.exit(1);
    }
  );

process.on('SIGTERM', () => {
  shutdown();
});

process.on('SIGINT', () => {
  shutdown();
});

//attempt to do a graceful shutdown
async function shutdown() {
  /* const sockets = ServiceLoader.getInstance().get(SocketIO);
  if (sockets) {
    try {
      //await sockets.cleanup();
      process.exit();
    } catch (err) {
      process.exit(1);
    }
  } else {
    process.exit();
  } */
}
