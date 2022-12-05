// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
const knex = require('knex')({
  client: 'mysql2',
  connection: {
    host: 'group-project-3-database-cluster.cluster-cwifrjgmyixo.us-east-2.rds.amazonaws.com',
    port : 3306,
    user : 'admin',
    password : 'adminadmin',
    database : 'Doughnuts'
  }
});


export default async function handler(req, res) {
  const doughnuts = await knex('Doughnuts');

  res.status(200).json(doughnuts)
}
