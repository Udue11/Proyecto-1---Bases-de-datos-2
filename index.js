//var http = require('http');
//const url = require('url');

//************************************** CREACION DEL SERVIDOR EXPRESS ****************************************
const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const port = 3000;

app.get('/', (request, response) => {
  response.json({ info: request.body })
})


//************************************** CLIENTE ****************************************
//----------------------------- ESPECIFICO ------------------------------
app.get('/clienteE/:id', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceClienteEspecifica')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- GENERAL ------------------------------
app.get('/clienteG/:Name/:Category/:DeliveryMethod', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pName', sql.VarChar(102), request.params.Name)
    .input('pCategory', sql.VarChar(52), request.params.Category)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.DeliveryMethod)

    .execute('dbo.proceClienteGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});


//************************************** PROVEEDORES ****************************************
//----------------------------- ESPECIFICO ------------------------------
app.get('/proveedorE/:id', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceProveedorEspecifica')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- GENERAL ---------------------------------
app.get('/proveedorG/:Name/:Category/:DeliveryMethod', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pName', sql.VarChar(102), request.params.Name)
    .input('pCategory', sql.VarChar(52), request.params.Category)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.DeliveryMethod)
    .execute('dbo.proceProveedoresGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});


//************************************** INVENTARIO ****************************************
//----------------------------- ESPECIFICO ------------------------------
app.get('/inventarioE/:id', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceInventarioEspecifica')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- GENERAL ----------------------------------
app.get('/inventarioG/:ProName/:Group/:stock', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pProdName', sql.VarChar(102), request.params.ProName)
    .input('pGroup', sql.VarChar(52), request.params.Group)
    .input('CantStock', sql.Int, request.params.stock)
    .execute('dbo.proceInventariosGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});


//************************************** VENTAS ****************************************
//----------------------------- ESPECIFICO ------------------------------
app.get('/ventaE/:id', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceVentaEspecifica')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- GENERAL ----------------------------------
app.get('/ventaG/:factura/:cliente/:delivery/:fechaMin/:fechaMax/:montoMin/:montoMax', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('NFactura', sql.Int, request.params.factura)
    .input('pCustName', sql.VarChar(102), request.params.cliente)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.delivery)
    .input('MinFecha', sql.Date, request.params.fechaMin)
    .input('MaxFecha', sql.Date, request.params.fechaMax)
    .input('MinMonto', sql.Int, request.params.montoMin)
    .input('MaxMonto', sql.Int, request.params.montoMax)
    .execute('dbo.proceVentasGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
});


//************************************** ESTADISTICOS ****************************************
//----------------------------- PRIMERO ----------------------------------
app.get('/estadistico/proveedor/:name', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('Name', sql.VarChar(102), request.params.name)
    .execute('dbo.procePrimeroEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- SEGUNDO ----------------------------------
app.get('/estadistico/cliente/:name', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('Name', sql.VarChar(102), request.params.name)
    .execute('dbo.proceSegundoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })
});
//----------------------------- TERCERO ----------------------------------
app.get('/estadistico/ganancias/:minyear/:maxyear/:minmonth/:maxMonth', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceTerceroEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
});
//----------------------------- CUARTO ----------------------------------
app.get('/estadistico/cliente-frecuente/:minyear/:maxyear/:minmonth/:maxMonth', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceCuartoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
});
//----------------------------- QUINTO ----------------------------------
app.get('/estadistico/proveedor-frecuente/:minyear/:maxyear/:minmonth/:maxMonth', (request, response) => {
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceQuintoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  }) 
});


//******************************************************************************
app.listen(port, () => {
   console.log(`Servidor alojado en el puerto: ${port}.`)
  console.log(config)
})

//************************************** CONEXION ****************************************
const sql = require('mssql');
const { pid } = require('process');
const { isDate } = require('util');
const config = {
    user: 'sa',
    password : '1234',
    server: 'localhost', 
    database: 'WideWorldImporters',
    "options": {
      "encrypt": true,
      "enableArithAbort": true
      }
  }


//************************************** CLIENTE ****************************************
//----------------------------- ESPECIFICO ------------------------------
async function proceClienteEspecifica (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceClienteEspecifica')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}
//----------------------------- GENERAL ------------------------------
async function proceClienteGeneral (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pName', sql.VarChar(102), request.params.Name)
    .input('pCategory', sql.VarChar(52), request.params.Category)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.DeliveryMethod)
    .execute('dbo.proceClienteGeneral')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}


//************************************** PROVEEDORES ****************************************
//----------------------------- ESPECIFICO ------------------------------
async function proceProveedorEspecifica (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceProveedorEspecifica')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}
//----------------------------- GENERAL ---------------------------------
async function proceProveedorGeneral (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pName', sql.VarChar(102), request.params.Name)
    .input('pCategory', sql.VarChar(52), request.params.Category)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.DeliveryMethod)
    .execute('dbo.proceProveedoresGeneral')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}


//************************************** INVENTARIO ****************************************
//----------------------------- ESPECIFICO ------------------------------
async function proceInventarioEspecifica (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceInventarioEspecifica')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}
//----------------------------- GENERAL ----------------------------------
async function proceInventariosGeneral (){    
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pProdName', sql.VarChar(102), request.params.ProName)
    .input('pGroup', sql.VarChar(52), request.params.Group)
    .input('CantStock', sql.Int, request.params.stock)
    .execute('dbo.proceInventariosGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}


//************************************** VENTAS ****************************************
//----------------------------- ESPECIFICO ------------------------------
async function proceVentaEspecifica (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('pID', sql.Int, request.params.id)
    .execute('dbo.proceVentaEspecifica')
    }).then(result =>{
      console.log(result.recordset)
      sql.close();      
    }).catch(err=>{
      console.log(err);
      sql.close();
    });     
}
//----------------------------- GENERAL ----------------------------------
async function proceVentasGeneral (){    
  sql.connect(config).then(pool => {
    return pool.request()
    .input('NFactura', sql.Int, request.params.factura)
    .input('pCustName', sql.VarChar(102), request.params.cliente)
    .input('pDeliveryMethod', sql.VarChar(52), request.params.delivery)
    .input('MinFecha', sql.Date, request.params.fechaMin)
    .input('MaxFecha', sql.Date, request.params.fechaMax)
    .input('MinMonto', sql.Int, request.params.montoMin)
    .input('MaxMonto', sql.Int, request.params.montoMax)
    .execute('dbo.proceVentasGeneral')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}


//************************************** ESTADISTICOS ****************************************
//----------------------------- PRIMERO ----------------------------------
async function procePrimeroEstadistico (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('Name', sql.VarChar(102), request.params.name)
    .execute('dbo.procePrimeroEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}
//----------------------------- SEGUNDO ----------------------------------
async function proceSegundoEstadistico (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('Name', sql.VarChar(102), request.params.name)
    .execute('dbo.proceSegundoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}
//----------------------------- TERCERO ----------------------------------
async function proceTerceroEstadistico (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceTerceroEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}
//----------------------------- CUARTO ----------------------------------
async function proceCuartoEstadistico (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceCuartoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  })  
}
//----------------------------- QUINTO ----------------------------------
async function proceQuintoEstadistico (){        
  sql.connect(config).then(pool => {
    return pool.request()
    .input('MinYear', sql.Int, request.params.minyear)
    .input('MaxYear', sql.Int, request.params.maxyear)
    .input('MinMonth', sql.Int, request.params.minmonth)
    .input('MaxMonth', sql.Int, request.params.maxMonth)
    .execute('dbo.proceQuintoEstadistico')  
  }).then(result =>{       
    response.json(result.recordset)
    sql.close();        
  }).catch(err=>{
    console.log(err);
    sql.close();
  }) 
}