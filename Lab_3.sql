use MuseumDB

create table Janitors
    ( JanitorID int not null primary key identity
    , name varchar(50) not null
    )


create or alter procedure addMuseumSpecialityColumn as
begin
  alter table Museums
  add Speciality text
end
go

create or alter procedure removeMuseumSpecialityColumn as
begin
  alter table Museums
  drop column Speciality
 end
go

create or alter procedure addDefaultTicketPrice as
begin
  alter table Tickets
  add constraint df_price
  default 5 for TicketPrice
end;
go

create or alter procedure removeDefaultTicketPrice as
begin
  alter table Tickets
   drop constraint df_price
end;
go

create or alter procedure createWebsiteTable as
  create table Websites
    ( id int not null primary key identity
    , url varchar(50) not null
    )
go

create or alter procedure dropWebsiteTable as
begin
	drop table Websites
end
go


create or alter procedure addMuseumForeignKey as
begin
    alter table Janitors
	add constraint fk_janitors foreign key (JanitorID) references Museums(MuseumID);
end;
go

create or alter procedure removeMuseumForeignKey as
begin
    alter table Janitors
    drop constraint fk_janitors;
end;
go

exec addMuseumSpecialityColumn
exec removeMuseumSpecialityColumn

exec addDefaultTicketPrice
exec  removeDefaultTicketPrice

exec createWebsiteTable
exec dropWebsiteTable

exec addMuseumForeignKey
exec removeMuseumForeignKey


create table CurrentVersion(currentVersion int)
insert into CurrentVersion values (0)


create table Versions(versionFrom int, versionTo int, doProc nvarchar(100), undoProc nvarchar(100))
insert into Versions values
  (0, 1, 'addMuseumSpecialityColumn', 'removeMuseumSpecialityColumn')
, (1, 2, 'addDefaultTicketPrice', 'removeDefaultTicketPrice')
, (2, 3, 'createWebsiteTable', 'dropWebsiteTable')
, (3, 4, 'addMuseumForeignKey', 'removeMuseumForeignKey')
go

create or alter procedure goToVersion @version int as begin
  declare @crrVersion int
  set @crrVersion = (select currentVersion from CurrentVersion)

	if @version < 0 or @version > (select COUNT(*) from Versions) begin
		raiserror ('Invalid version.', 10, 0)
		return
	end

  if @version = @crrVersion begin
		return 
	end

  declare @versionDelta int

	if @version > @crrVersion begin
    set @versionDelta = 1
		declare versionCursor cursor for
			select doProc from Versions
			where versionTo <= @version and versionFrom >= @crrVersion
			order by versionFrom
	end
	else begin
    set @versionDelta = -1
		declare versionCursor cursor for
			select undoProc from Versions
			where versionFrom >= @version and versionTo <= @crrVersion
			order by versionTo desc
	end

	declare @proc nvarchar(100)
	open versionCursor
	fetch next from versionCursor into @proc

	while @@FETCH_STATUS = 0 begin
		exec @proc

    update CurrentVersion
    set currentVersion = @crrVersion + @versionDelta

    set @crrVersion = @crrVersion + @versionDelta

		fetch next from versionCursor into @proc
	end
  
	close versionCursor
	deallocate versionCursor
end
go

EXEC goToVersion @version = 1;
select * from CurrentVersion