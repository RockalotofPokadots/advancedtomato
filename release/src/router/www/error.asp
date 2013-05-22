<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv='content-type' content='text/html;charset=utf-8'>
        <meta name='robots' content='noindex,nofollow'>
        <title>[<% ident(); %>] Error</title>

        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/bootstrap-responsive.min.css" rel="stylesheet">
        <link href="css/tomato.css" rel="stylesheet">
        <% css(); %>


        <script type="text/javascript" src="js/jquery.lite.min.js"></script>


    </head>
    <body>
    <div class="container" style="text-align: center;">
        <div class="row">
            <h2>Somthing went wrong...</h2>
            <p><script type='text/javascript'>
                    //<% resmsg('Unknown error'); %>
                    document.write(resmsg);
                </script></p>
            <p><a class="btn btn-primary" onclick='history.go(-1)'>Go Back</a></p>
        </div>
    </div>
</html>
