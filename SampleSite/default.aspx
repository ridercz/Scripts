<!DOCTYPE html>
<%@ Page Language="C#" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Welcome to
        <%= Request.Url.Host %>
    </title>
    <style type="text/css">
        body {
            font-family: Consolas , 'Courier New' , Monospace;
        }
        th {
            text-align: left;
        }
    </style>
</head>
<body>
    <h1>
        <%= Request.Url.Host %>
    </h1>
    <table>
        <tr>
            <th>Host name:</th>
            <td>
                <%= Request.Url.Host %>
            </td>
        </tr>
        <tr>
            <th>Request identity:</th>
            <td>
                <%= System.Security.Principal.WindowsIdentity.GetCurrent().Name %>
            </td>
        </tr>
    </table>
</body>
</html>
