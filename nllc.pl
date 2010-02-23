{
    name        => 'NLLC',
    'Model::DB' => {
        schema_class => 'NLLC::Schema',
        connect_info =>
          [ 'dbi:mysql:dbname=nllc;host=mysql.odshank.com;user=nllc_admin;password=nllc2hs' ],
    }
}
