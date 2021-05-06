
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="ar.org.centro8.curso.java.connectors.Connector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/style_1.css"/>
        <title>Articulos</title>
    </head>
    <body>


        <%
    String tabla = "";

    String buscarDescripcion=request.getParameter("buscarDescripcion");
    if(buscarDescripcion==null) buscarDescripcion="";
    String buscarTemporada=request.getParameter("buscarTemporada");
    if(buscarTemporada==null) buscarTemporada="";
     String buscarTipo=request.getParameter("buscarTipo");
    if(buscarTipo==null) buscarTipo="";
     String buscarTalle=request.getParameter("buscarTalle");
    if(buscarTalle==null) buscarTalle="";
     String buscarColor=request.getParameter("buscarColor");
    if(buscarColor==null) buscarColor="";
    try (ResultSet rs=Connector
            .getConnection()
            .createStatement()
            .executeQuery(
                    "select * from articulos "
                        + "where descripcion like '%"+buscarDescripcion+"%' "
                        + "and temporada like '%"+ buscarTemporada+"%'"
                        + "and tipo like '%"+ buscarTipo+"%'"
                        + "and talle_num like '%"+ buscarTalle+"%'"
                        + "and color like '%"+ buscarColor+"%'"


            )){
        tabla += "<table  id='registros'>";
        tabla += "<tr><th>Id</th><th>Descripcion</th><th>Tipo</th><th>Color</th>"
                + "<th>Talle/num</th><th>Stock</th><th>StockMin</th>"
                + "<th>StockMax</th><th>Costo</th><th>Precio</th><th>Temporada</th></tr>";
        while(rs.next()){
            tabla += "<tr>";
            tabla += "<td>"+rs.getInt("id")+"</td>";
            tabla += "<td>"+rs.getString("descripcion")+"</td>";
            tabla += "<td>"+rs.getString("tipo")+"</td>";
            tabla += "<td>"+rs.getString("color")+"</td>";
            tabla += "<td>"+rs.getString("talle_num")+"</td>";
            tabla += "<td>"+rs.getInt("stock")+"</td>";
            tabla += "<td>"+rs.getInt("stockMin")+"</td>";
            tabla += "<td>"+rs.getInt("stockMax")+"</td>";
            tabla += "<td>"+rs.getDouble("costo")+"</td>";
            tabla += "<td>"+rs.getDouble("precio")+"</td>";
            tabla += "<td>"+rs.getString("temporada")+"</td>";
            tabla += "</tr>";
        }
        tabla += "</table>";

    } catch (Exception e) {
      tabla = e.toString();
    }
            %>

            <%
    String respuesta = "";
    try {
    String descripcion=request.getParameter("descripcion");
    String tipo=request.getParameter("tipo");
    String color=request.getParameter("color");
    String talle_num=request.getParameter("talle_num");
    int stock=Integer.parseInt(request.getParameter("stock"));
    int stockMin=Integer.parseInt(request.getParameter("stockMin"));
    int stockMax=Integer.parseInt(request.getParameter("stockMax"));
    Double costo=Double.parseDouble(request.getParameter("costo"));
    Double precio=Double.parseDouble(request.getParameter("precio"));
    String temporada=request.getParameter("temporada");



    try(PreparedStatement ps=Connector
           .getConnection()
           .prepareStatement(
               "insert into articulos "
                   + "(descripcion,tipo,color,talle_num,stock,stockMin,stockMax,costo,precio,temporada) "
                   + "values (?,?,?,?,?,?,?,?,?,?)",
                   PreparedStatement.RETURN_GENERATED_KEYS
           )){
            ps.setString(1,descripcion);
            ps.setString(2,tipo);
             ps.setString(3,color);
             ps.setString(4,talle_num);
            ps.setInt(5,stock);
            ps.setInt(6,stockMin);
            ps.setInt(7,stockMax);
            ps.setDouble(8,costo);
            ps.setDouble(9,precio);
            ps.setString(10,temporada);

            ps.execute();
            ResultSet rs=ps.getGeneratedKeys();
            int id=0;
            if(rs.next()) id=rs.getInt(1);
            if(id==0){
                respuesta = "No se pudo dar de alta el registro";
            }else{
                respuesta = "Se guardo el articulo id: "+id;
            }
    } catch (Exception e) {
       respuesta = e.toString();
    }

    } catch (Exception e) {
    respuesta = "*Los campos son obligatorios ";
    }
            %>
        <div class="grid-container">
            <div class="buscar">
                <h1>MANTENIMIENTO DE ARTICULOS</h1>
                <form>
                    <table id="busqueda">
                        <tr>
                            <td class="label"><h3>BUSCAR ARTICULOS:  </h3></td>
                            <td> por descripcion:</td>
                            <td><input type="text" name="buscarDescripcion" value="" /></td>

                            <td>por temporada:</td>
                            <td><input type="text" name="buscarTemporada" value="" /></td>
                            <td>por tipo:</td>
                            <td><input type="text" name="buscarTipo" value="" /></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>por talle:</td>
                            <td><input type="text" name="buscarTalle" value="" /></td>
                            <td>por color:</td>
                            <td><input type="text" name="buscarColor" value="" /></td>
                            <td></td>
                            <td><input type="submit" value="BUSCAR"/></td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="ingresar">
                <h3>INGRESAR NUEVO ARTICULO:</h3>
                <form >
                    <table>
                        <tr>
                            <td>*Descripcion:                 </td>
                            <td><input type="text"  name="descripcion" minlength="3" maxlength="25" required /></td>
                        </tr>
                        <tr>
                            <td>*Tipo: </td>

                            <td>
                                <select name="tipo">
                                    <option value="CALZADO" selected >CALZADO</option>
                                    <option value="ROPA">ROPA</option>                            
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>*Color:</td>
                            <td><input type="text"  name="color" minlength="3" maxlength="20" required/></td>
                        </tr>
                        <tr>
                            <td>*Talle:</td>
                            <td><input type="text"  name="talle_num" minlength="3" maxlength="20" required/></td>
                        </tr>
                        <tr>
                            <td>*Stock:</td>
                            <td><input type="number" name="stock"/></td>
                        </tr>
                        <tr>
                            <td>*Stock Minimo:</td>
                            <td><input type="number" name="stockMin"/></td>
                        </tr>
                        <tr>
                            <td>*Stock Maximo:</td>
                            <td><input type="number" name="stockMax"/></td>
                        </tr>
                        <tr>
                            <td>*Costo:</td>
                            <td><input type="number" name="costo" min="1"  required/></td>
                        </tr>
                        <tr>
                            <td>*Precio:</td>
                            <td><input type="number" name="precio" required/></td>
                        </tr>
                        <tr>
                            <td>*Temporada:</td>
                            <td>
                                <select name="temporada">
                                    <option value="VERANO" selected >VERANO</option>
                                    <option value="OTOÑO">OTOÑO</option>
                                    <option value="INVIERNO">INVIERNO</option>
                                </select>
                            </td>
                        <tr>
                            <td ><input type="reset" value="BORRAR"/></td>
                            <td><input type="submit" value="ENVIAR"/></td>
                        </tr>
                    </table>
                </form>
            </div> 
            <div class="salida">
                <h4>
                    <%
                        out.println(respuesta);
                    %>
                </h4>
            </div> 
            <div class="tabla">                                     
                <%
                out.println(tabla);
                %>
            </div>
        </div>
    </body>
</html>
