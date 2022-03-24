// this file has the baseline default parameters
{
  components: 
  {
    myapp: 
    {
      indexData: 'myapp baseline\n',
      fimage: 'aksdoc/kub-frontend:latest',
      bimage: 'aksdoc/kub-backend:latest',
      dbimage: 'postgres:13-alpine',
      fport: 8000,
      bport: 9000,
      dbport: 5432,
      //replicas: 1,
    },
  }
}
