program nueve;
	const ValorAlto= 'zzzz';
type 
	InfoVuelo=record
		dest:string;
		fecha:string;
		hora:string;
		cantAsiDisp:integer;
	end;
	ArchM= file of InfoVuelo;
	
	InfoDiario=record
		dest:string;
		fecha:string;
		hora:string;
		cantAsiReserv:integer;
	end;
	ArchD= file of InfoDiario;

	lista=^nodo;
	nodo = record
		vuelo:InfoVuelo;
		sig:lista;
	end;
var
	l:lista;
	cantidad:integer;
	regm: InfoVuelo;
	min, regd1, regd2: InfoDiario;
	mae1: ArchM;
	det1,det2: ArchD;
	aux: string [4]; {PARA EL VALOR ALTO}

procedure leer (var archivo:ArchD ; var dato:InfoDiario);
begin
	if (not eof(archivo)) then 
		read (archivo,dato)
	else
		dato.dest := valoralto;
end;

procedure minimo (var r1:InfoDiario; var r2:InfoDiario; var min:InfoDiario);
begin
	if (r1.dest<=r2.dest) then begin
		min := r1;
		leer(det1,r1)
	end
	else 
		min := r2;
		leer(det2,r2)
end;

procedure AgregarElemento (var l:lista; mae1:InfoVuelo);
var 
	aux:lista;
begin
	new (aux);
	aux^.vuelo:=mae1;
	aux^.sig:=nil;
	if (l = nil) then
		l:=aux
	else 
		aux^.sig:=l;
		l:=aux;
	end;

begin
	assign (mae1, 'Mestro');
	assign (det1, 'detalle1');
	assign (det2, 'detalle2');
	reset (mae1);
	reset (det1);
	reset (det2);
	read (mae1, regm);
	leer (det1, regd1);
	leer (det2, regd2);
	minimo (regd1, regd2, min);
	writeln ('Ingrese una cantidad por teclado: ');
	readln (cantidad);
	l:=nil;
	while (min.dest <> ValorAlto) do begin
		while (regm.dest <> min.dest) do
			if (regm.cantAsiDisp < cantidad)then
				AgregarElemento (l, regm);
			read (mae1, regm);
		aux:=min.dest;
		while (aux = min.dest) do begin
			regm.cantAsiDisp:= regm.cantAsiDisp - min.cantAsiReserv;
			minimo (regd1, regd2, min);
		end;
		if (regm.cantAsiDisp < cantidad)then
			AgregarElemento (l, regm);
		seek (mae1, filepos(mae1)-1);
		write (mae1, regm);
		if (not EOF(mae1)) then 
			read (mae1, regm);
	close (mae1);
	close (det1);
	close (det2);
	end;
end.

