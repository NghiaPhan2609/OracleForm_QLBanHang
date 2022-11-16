

CREATE TABLE LOAISP
(
    MaLoaiSP VARCHAR2(20) PRIMARY KEY ,
    TenLoaiSP NVARCHAR2(100),
    ThuongHieu NVARCHAR2(100),
    XuatXu NVARCHAR2(50)
);

CREATE TABLE NHACUNGCAP
(
    MaNCC VARCHAR2(20) PRIMARY KEY,
    TenNCC NVARCHAR2(100),
    SdtNCC VARCHAR(20),
    KhuVuc NVARCHAR2(20),
    DiaChiNCC NVARCHAR2(100),
    ThuongHieuCC NVARCHAR2(100)
);

CREATE TABLE SANPHAM
(
    MaSP VARCHAR2(20) PRIMARY KEY,
    TenSP NVARCHAR2(100),
    DonGia FLOAT,
    SoLuongTon INT,
    TinhTrangSP NVARCHAR2(50),
    NamSX INT,
    DungTich VARCHAR2(20),
    NongDo NVARCHAR2(50),
    PhongCach NVARCHAR2(100),
    GioiTinh NVARCHAR2(20),
    DoToaHuong NVARCHAR2(50),
    DoLuuHuong NVARCHAR2(50),
    NhomHuong NVARCHAR2(100),
    MoTa NVARCHAR2(255),
    HinhAnh1 VARCHAR2(100),
    HinhAnh2 VARCHAR2(100),
    GhiChuSP NVARCHAR2(20),
    MaLoaiSP VARCHAR2(20) REFERENCES LOAISP(MaLoaiSP) 
); 


CREATE TABLE CHINHANH 
(
    MaCN VARCHAR2(20) PRIMARY KEY,
    TenCN NVARCHAR2(100),
    SdtCN VARCHAR(20),
    KhuVuc NVARCHAR2(20),
    DiaChiCN NVARCHAR2(100)
)

CREATE TABLE NHANVIEN 
(
    MaNV VARCHAR2(20) PRIMARY KEY,
    TenNV NVARCHAR2(60),
    SdtNV VARCHAR2(20),
    ChucVu NVARCHAR2(20),
    TenDN VARCHAR(60),
    MatKhau VARCHAR(20),
    MaCN VARCHAR2(20) REFERENCES CHINHANH(MaCN) 
)

CREATE TABLE PHIEUNHAP
(
    MaPhieuNhap VARCHAR2(20) PRIMARY KEY,
    NgayNhap DATE,
    TongTienNhap FLOAT,
    TinhTrang NVARCHAR2(20),
    MaNCC VARCHAR2(20) REFERENCES NHACUNGCAP(MaNCC), 
    MaNV VARCHAR2(20) REFERENCES NHANVIEN(MaNV), 
    MaCN VARCHAR2(20) REFERENCES CHINHANH(MaCN) 
)

CREATE TABLE CTPHIEUNHAP
(
    MaPhieuNhap VARCHAR2(20) REFERENCES PHIEUNHAP(MaPhieuNhap),
    MaSP VARCHAR2(20) REFERENCES SANPHAM(MaSP),
    DonGiaNhap FLOAT,
    SoLuongNhap INT,
    PRIMARY KEY(MaSP,MaPhieuNhap)
)


CREATE TABLE KHACHHANG
(
    MaKH VARCHAR2(20) PRIMARY KEY,
    TenKH NVARCHAR2(50),
    SdtKH VARCHAR2(20),
    DiaChiKH NVARCHAR2(100),
    NgaySinh DATE,
    Email VARCHAR2(60),
    TenDN VARCHAR2(60),
    MatKhau VARCHAR2(20)  
)


CREATE TABLE KHUYENMAI
(
    MaKM VARCHAR2(20) PRIMARY KEY,
    TenKM NVARCHAR2(100), 
    NgayBD DATE,
    NgayKT DATE,
    PhanTramGiam FLOAT,
    TienMuaToiThieu FLOAT,
    TienGiamToiDa FLOAT
)

CREATE TABLE HOADON
(
    MaHD VARCHAR2(20) PRIMARY KEY,
    MaKM VARCHAR2(20) REFERENCES KHUYENMAI(MaKM),
    NgayLapHD DATE,
    TrangThaiHD NVARCHAR2(20),
    ThanhTienHD FLOAT,
    GiamGia FLOAT ,
    TongTienHD FLOAT,
    NgayTT DATE,
    TinhTrangThanhToan NVARCHAR2(20),
    HinhThucTT NVARCHAR2(20),
    DiaChiGiaoHang NVARCHAR2(100),
    NgayGiao DATE,
    TinhTrangGiao NVARCHAR2(20),
    MaKH VARCHAR2(20) REFERENCES KHACHHANG(MaKH),
    MaNV VARCHAR2(20) REFERENCES NHANVIEN(MaNV)
)


CREATE TABLE CTHOADON
(
    MaHD VARCHAR2(20) REFERENCES HOADON(MaHD),
    MaSP VARCHAR2(20) REFERENCES SANPHAM(MaSP),
    DonGiaBan FLOAT,
    SoLuong INT,
    PRIMARY KEY(MaSP,MaHD) 
)






SELECT * FROM chinhanh;
DELETE FROM chinhanh;






create or replace NONEDITIONABLE PROCEDURE "Them_ChiNhanh"
                            (p_TenCN IN VARCHAR2 , 
                            p_SdtCN IN VARCHAR2 ,
                            p_KhuVuc IN NVARCHAR2  , 
                              p_DiaChi IN NVARCHAR2  )
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  dem float;
  ID VARCHAR2(20);   
BEGIN

    SELECT  COUNT(*) INTO temp_c1
    FROM chinhanh;
     
    SELECT MAX(SUBSTR(RTRIM(macn),3,3)) INTO temp_c2
    FROM chinhanh;
    
    SELECT COUNT(*) INTO dem
    FROM chinhanh
    WHERE REPLACE(UPPER(TENCN),' ')=REPLACE(UPPER(p_TenCN),' ');
   
    IF dem=1 THEN
         raise_application_error(-20001,'Chi nhánh đã tồn tại'); 
    END IF;
	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;
    
    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('CN00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('CN0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('CN',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;
    
   INSERT INTO CHINHANH(MACN,TENCN,SDTCN,KHUVUC,DIACHICN)
    VALUES(ID,p_TenCN,p_SdtCN,p_KhuVuc,p_DiaChi);


END;


BEGIN
  "Them_ChiNhanh"('NPTK-Đông Nam','090394123','TP.HCM','12 Sư Vạn Hạnh');
  "Them_ChiNhanh"('NPTK-Đông Bắc','028234234','Hà Nội','38 Xuân Thủy');
--rollback; 
END;






SELECT * FROM loaisp;
DELETE FROM loaisp;


create or replace NONEDITIONABLE PROCEDURE "Them_LoaiSP"
                            ( ptenlsp IN NVARCHAR2 ,
                            pthuonghieu IN NVARCHAR2 , 
                              pxuatxu IN NVARCHAR2  )
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  ID VARCHAR2(20);
     
BEGIN

    SELECT  COUNT(*) INTO temp_c1
    FROM loaisp;
     

    SELECT MAX(SUBSTR(RTRIM(maloaisp),4,3)) INTO temp_c2
    FROM loaisp;

	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;
    
    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('LSP00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('LSP0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('LSP',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;
    
   INSERT INTO LOAISP(MALOAISP,TENLOAISP,THUONGHIEU,XUATXU)
    VALUES(ID,ptenlsp,pthuonghieu,pxuatxu);


END;




BEGIN
  "Them_LoaiSP"('Chanel Coco','Chanel','Pháp');
  "Them_LoaiSP"('Chanel No5','Chanel','Pháp');
  "Them_LoaiSP"('Miss Dior','Dior','Pháp');
  "Them_LoaiSP"('Dior Sauvage','Dior','Pháp');
  "Them_LoaiSP"('Versace Eros','Versace','Ý');
  "Them_LoaiSP"('Versace Pour Homme','Versace','Ý');  
--rollback; 
END;


    
    
    

SELECT * FROM sanpham;
DELETE FROM sanpham;


create or replace NONEDITIONABLE PROCEDURE "Them_SanPham"
                            ( ptensanpham IN NVARCHAR2 ,
                              pdongia IN float  , 
                              pnamsx IN INT,
                              pdungtich IN VARCHAR2,
                              pnongdo IN NVARCHAR2,
                              pphongcach IN NVARCHAR2,
                              pgioitinh IN NVARCHAR2,
                              pdotoahuong IN NVARCHAR2,
                              pdoluuhuong IN NVARCHAR2,
                              pnhomhuong IN NVARCHAR2,
                              pmota IN NVARCHAR2,
                              phinhanh1 VARCHAR2,
                              phinhanh2 VARCHAR2,
                              pghichusp NVARCHAR2,
                              pmaloaisp VARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  ID VARCHAR2(20);

BEGIN

    SELECT  COUNT(*) into temp_c1
    FROM sanpham; 

    SELECT MAX(SUBSTR(RTRIM(masp),3,3)) into temp_c2
    FROM sanpham;

	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;

    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('SP00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('SP0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('SP',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;

   INSERT INTO SANPHAM (MASP,TENSP,DONGIA,SOLUONGTON,TINHTRANGSP,NAMSX,DUNGTICH,NONGDO,PHONGCACH,GIOITINH,DOTOAHUONG,DOLUUHUONG,NHOMHUONG,MOTA,HINHANH1,HINHANH2,GHICHUSP,MALOAISP) 
   VALUES(ID,CONCAT(CONCAT(ptensanpham,' '),pdungtich),pdongia,0,'hết hàng',pnamsx,pdungtich,pnongdo,pphongcach,pgioitinh,pdotoahuong,pdoluuhuong,pnhomhuong,pmota,phinhanh1,phinhanh2,pghichusp,pmaloaisp);


END;

BEGIN
  "Them_SanPham"('Chanel Coco Vaporisateur Spray',2750000,1984,'50ml','Eau de Parfum (EDP)','sang trọng,quyến rũ','Nam','2m','7-12h','Aromatic Fougere - hương thơm thảo mộc','hương đầu : Oriental Spicy ','','','Sản phẩm đơn','LSP001');
   "Them_SanPham"('Chanel No 5 Eau De Parfum',3960000,1986,'100ml','Eau de Parfum (EDP)','sang trọng,quyến rũ','Nữ','2m','7-12h','Floral Aldehyde- hương hoa cúc','hương đầu :Quýt,Đào,Hoa nhài','','','Sản phẩm đơn','LSP002');
--rollback; 
END;






create or replace NONEDITIONABLE PROCEDURE "Them_Nhacungcap"
                            ( ptenncc IN NVARCHAR2 ,
                            psdt IN NVARCHAR2  , 
                              pkhuvuc IN NVARCHAR2,
                              pdiachincc IN NVARCHAR2 ,
                              pthuonghiecc IN NVARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  ID VARCHAR2(20);
     
BEGIN
    
    SELECT  COUNT(*) INTO temp_c1
    FROM nhacungcap;
     

    SELECT MAX(SUBSTR(RTRIM(mancc),4,3)) INTO temp_c2
    FROM nhacungcap;
    

	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;
    
    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('NCC00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('NCC0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('NCC',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;
    
   INSERT INTO NHACUNGCAP(MANCC,TENNCC,SDTNCC,KHUVUC,DIACHINCC,THUONGHIEUCC)
    VALUES(ID,ptenncc,psdt,pkhuvuc,pdiachincc,pthuonghiecc);


END;


BEGIN
  "Them_Nhacungcap"('Chanel HCM','091029029','TP.HCM','45 Tôn Thất Tùng','Chanel');
  "Them_Nhacungcap"('Chanel Hà Nội','0281231243','Hà Nội','146 Đinh Tiên Hoàng','Chanel');
  "Them_Nhacungcap"('Dior HCM','078234123','TP.HCM','79 Sư Vạn Hạnh','Dior');
  "Them_Nhacungcap"('Dior Hà Nội','09813134','Hà Nội','89 Xuân Thủy','Dior');
  "Them_Nhacungcap"('Versace HCM','0907234234','TP.HCM','167 Nguyễn Huệ','Versace');
  "Them_Nhacungcap"('Versace Hà Nội','034571238','Hà Nội','90 Xóm Củi','Versace');
--rollback; 
END;






create or replace NONEDITIONABLE PROCEDURE "Them_Nhanvien"
                            ( ptennv IN NVARCHAR2 ,
                            psdt IN NVARCHAR2  , 
                            pchucvu IN NVARCHAR2,
                            pmacn IN NVARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  dem float;
  ID VARCHAR2(20);
     
BEGIN

    SELECT  COUNT(*) INTO temp_c1
    FROM nhanvien;
     

    SELECT MAX(SUBSTR(RTRIM(manv),3,3)) INTO temp_c2
    FROM nhanvien;
    
    SELECT COUNT(*) INTO dem
    FROM nhanvien
    WHERE REPLACE(UPPER(SDTNV),' ')=REPLACE(UPPER(psdt),' ');
    
    IF dem>0 THEN
        raise_application_error(-20001,'Số điên thoại đã tồn tại');
    END IF;
	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;
    
    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('NV00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('NV0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('NV',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;
    
   INSERT INTO NHANVIEN(MANV,TENNV,SDTNV,CHUCVU,TENDN,MATKHAU,MACN)
    VALUES(ID,ptennv,psdt,pchucvu,CONCAT(CONCAT(ID,'_'),pchucvu),'123456',pmacn);

END;


BEGIN
  "Them_Nhanvien"('Phan Hiếu Nghĩa','0293433','ql','CN001');
  "Them_Nhanvien"('Nguyễn Thành Thắng','09029321','banhang','CN001');
  "Them_Nhanvien"('Trần Văn A','0689667','kho','CN001');
   "Them_Nhanvien"('Khưu Hồng Tiến','0823434','ql','CN002');
  "Them_Nhanvien"('Trần Minh Long','0234234','banhang','CN002');
  "Them_Nhanvien"('Trần Văn B','0928343','kho','CN002');
--rollback; 
END;











create or replace NONEDITIONABLE PROCEDURE "Them_Phieunhap"
                                (pmancc IN NVARCHAR2,
                              pmanv IN NVARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  temp_c3 VARCHAR2(20); 
  temp_c4 DATE;
  ID VARCHAR2(20);
     
BEGIN

   
     SELECT  COUNT(*) INTO temp_c1
     FROM phieunhap;
     

     SELECT MAX(SUBSTR(RTRIM(maphieunhap),3,3)) INTO temp_c2
     FROM phieunhap;
    

     SELECT macn INTO temp_c3
     FROM nhanvien
     WHERE nhanvien.manv=pmanv;
    

    SELECT CURRENT_DATE INTO temp_c4
    FROM DUAL; 
   

	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;
    
    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('PN00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('PN0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('PN',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;

   INSERT INTO PHIEUNHAP(MAPHIEUNHAP,NGAYNHAP,TONGTIENNHAP,TINHTRANG,MANCC,MANV,MACN)
    VALUES(ID,temp_c4,0,'Chờ duyệt',pmancc,pmanv,temp_c3);


END;


BEGIN
  "Them_Phieunhap"('NCC001','NV003');   
  "Them_Phieunhap"('NCC003','NV003');
  "Them_Phieunhap"('NCC002','NV006');
  "Them_Phieunhap"('NCC004','NV006');
--rollback; 
END;



CREATE OR REPLACE trigger Trg_Insert_TONGTIENNHAP 
		AFTER INSERT  ON ctphieunhap
		FOR EACH ROW
		BEGIN
			   UPDATE phieunhap 
               SET TONGTIENNHAP=TONGTIENNHAP+ :NEW.DONGIANHAP*:NEW.SOLUONGNHAP 
               WHERE :NEW.maphieunhap = phieunhap.MAPHIEUNHAP;
        END;
        
CREATE OR REPLACE trigger Trg_Delete_TONGTIENNHAP 
		AFTER DELETE  ON ctphieunhap
		FOR EACH ROW
		BEGIN
			   UPDATE phieunhap 
               SET TONGTIENNHAP=TONGTIENNHAP - :OLD.DONGIANHAP*:OLD.SOLUONGNHAP 
               WHERE :OLD.maphieunhap = phieunhap.MAPHIEUNHAP;
        END;
              
CREATE OR REPLACE trigger Trg_Update_TONGTIENNHAP 
		AFTER UPDATE ON ctphieunhap
		FOR EACH ROW
		BEGIN
               UPDATE phieunhap 
               SET TONGTIENNHAP=TONGTIENNHAP+ :NEW.DONGIANHAP*:NEW.SOLUONGNHAP 
               WHERE :NEW.maphieunhap = phieunhap.MAPHIEUNHAP;
               
			   UPDATE phieunhap 
               SET TONGTIENNHAP=TONGTIENNHAP - :OLD.DONGIANHAP*:OLD.SOLUONGNHAP 
               WHERE :OLD.maphieunhap = phieunhap.MAPHIEUNHAP;
        END;
        
        
        
        
                
CREATE OR REPLACE trigger Trg_Update_TinhTrangPN
BEFORE UPDATE ON CTPHIEUNHAP
FOR EACH ROW
DECLARE
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT phieunhap.TINHTRANG
     FROM phieunhap
     WHERE phieunhap.maphieunhap=:NEW.MAPHIEUNHAP;
    
BEGIN
    open c1;
    fetch c1 into temp_c1;
    close c1;
    
    IF temp_c1 ='Từ chối' THEN
     UPDATE phieunhap 
     SET tinhtrang='Chờ duyệt' 
     WHERE PHIEUNHAP.MAPHIEUNHAP = :NEW.MAPHIEUNHAP ;
    END IF;
END;



create or replace NONEDITIONABLE PROCEDURE "Duyet_PhieuNhap"
                                (pmapn IN VARCHAR2)
AS 
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT TINHTRANG
     FROM phieunhap
     WHERE maphieunhap=pmapn;
BEGIN

  open c1;
   fetch c1 into temp_c1;
   close c1;
    
    IF temp_c1 ='Đã duyệt' THEN
     raise_application_error(-20001,'Phiếu Nhập này đã được duyệt'); 
    END IF;
    
    UPDATE PHIEUNHAP
    SET TINHTRANG='Đã duyệt'
    WHERE MAPHIEUNHAP=pmapn;
    
    UPDATE CTPHIEUNHAP
    SET MAPHIEUNHAP=pmapn
    WHERE MAPHIEUNHAP=pmapn;
END;


create or replace NONEDITIONABLE PROCEDURE "HoanTac_PhieuNhap"
                                (pmapn IN VARCHAR2)
AS 
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT TINHTRANG
     FROM phieunhap
     WHERE maphieunhap=pmapn;
BEGIN

  open c1;
   fetch c1 into temp_c1;
   close c1;
    
    IF temp_c1 ='Từ chối' THEN
     raise_application_error(-20001,'Không thể hoàn tác'); 
    END IF;
    
    UPDATE PHIEUNHAP
    SET TINHTRANG='Đã hoàn tác'
    WHERE MAPHIEUNHAP=pmapn;
    
    UPDATE CTPHIEUNHAP
    SET MAPHIEUNHAP=pmapn
    WHERE MAPHIEUNHAP=pmapn;
END;



create or replace NONEDITIONABLE PROCEDURE "TuChoi_PhieuNhap"
                                (pmapn IN VARCHAR2)
AS 
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT TINHTRANG
     FROM phieunhap
     WHERE maphieunhap=pmapn;
BEGIN

  open c1;
   fetch c1 into temp_c1;
   close c1;
    
    IF temp_c1 ='Đã duyệt' THEN
     raise_application_error(-20001,'Phiếu Nhập này đã được duyệt'); 
    END IF;
    
    UPDATE PHIEUNHAP
    SET TINHTRANG='Từ chối'
    WHERE MAPHIEUNHAP=pmapn;
END;




CREATE OR REPLACE trigger Trg_Update_SOLUONGTON
BEFORE UPDATE OF MAPHIEUNHAP ON CTPHIEUNHAP
FOR EACH ROW
DECLARE
temp_c1 NVARCHAR2(20);
temp_c2 NVARCHAR2(20);

cursor c1 is
     SELECT phieunhap.TINHTRANG
     FROM phieunhap
     WHERE phieunhap.maphieunhap=:NEW.MAPHIEUNHAP;
    
BEGIN
    open c1;
    fetch c1 into temp_c1;
    close c1;
    
     SELECT phieunhap.TINHTRANG
     INTO temp_c2
     FROM phieunhap
     WHERE phieunhap.maphieunhap=:OLD.MAPHIEUNHAP;
    
    IF temp_c1 ='Đã duyệt' THEN
         UPDATE sanpham 
         SET SOLUONGTON=SOLUONGTON+  :NEW.SOLUONGNHAP ,TINHTRANGSP='còn hàng'
         WHERE SANPHAM.MASP = :NEW.MASP ;
    ELSIF temp_c1='Đã hoàn tác' AND temp_c2 = 'Đã duyệt' THEN
         UPDATE sanpham 
         SET SOLUONGTON=SOLUONGTON-:NEW.SOLUONGNHAP
         WHERE SANPHAM.MASP = :NEW.MASP ;
    END IF;
END;

SELECT * FROM PHIEUNHAP
SELECT * FROM CTPHIEUNHAP
SELECT * FROM SANPHAM



  INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN001','SP001',300,3);
   INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN001','SP002',100,1);
   
  INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN002','SP001',200,2);
   INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN002','SP002',200,4);
   
   INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN003','SP001',300,20);
   INSERT INTO CTPHIEUNHAP(MAPHIEUNHAP,MASP,DONGIANHAP,SOLUONGNHAP) 
   VALUES ('PN003','SP002',400,20);


BEGIN
   "HoanTac_PhieuNhap"('PN001');   
--rollback; 
END;

BEGIN
   "Duyet_PhieuNhap"('PN001'); 
   "Duyet_PhieuNhap"('PN002'); 
   "Duyet_PhieuNhap"('PN003');   
--rollback; 
END;




create or replace NONEDITIONABLE PROCEDURE "Them_Khachhang"
                            ( ptenkh IN NVARCHAR2 ,
                            psdt IN NVARCHAR2  , 
                              pdiachi IN NVARCHAR2,
                              pngaysinh IN VARCHAR2,
                              pemail IN VARCHAR2,
                              ptendn IN NVARCHAR2 ,
                              pmatkhau IN NVARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  temp_c3 VARCHAR2(20); 
  ID VARCHAR2(20);

BEGIN

   
     SELECT  COUNT(*) INTO temp_c1
     FROM khachhang;

     SELECT MAX(SUBSTR(RTRIM(makh),3,3)) INTO temp_c2
     FROM khachhang;
     

     SELECT  COUNT(*) INTO temp_c3
     FROM khachhang
     WHERE khachhang.tendn=ptendn;

    IF temp_c3>0 THEN
        raise_application_error(-20001,'Tên đăng nhập đã tồn tại'); 
    END IF;
	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;

    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('KH00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('KH0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('KH',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;

   INSERT INTO KHACHHANG(MAKH,TENKH,SDTKH,DIACHIKH,NGAYSINH,EMAIL,TENDN,MATKHAU)
    VALUES(ID,ptenkh,psdt,pdiachi,TO_DATE(pngaysinh,'DD/MM/YYYY'),pemail,ptendn,pmatkhau);


END;


BEGIN
   "Them_Khachhang"('Nguyễn Văn Tèo',0192039,'48 Tôn Thất Thuyết','12/12/1999','teo@gmail','TeoNguyen','123');   
   "Them_Khachhang"('Trần Ngọc Bích',07896868,'145 Tôn Dật Tiên','06/08/2000','bich@gmail','BichTran','123'); 
   "Them_Khachhang"('Nguyễn Thị Bảo',034764756,'12 Đống Đa','09/12/1996','bao@gmail','BaoNguyen','123'); 
   "Them_Khachhang"('Phan Văn Đức',09087566,'65 Hồ Gươm','16/03/2002','duc@gmail','DucPhan','123'); 
--rollback; 
END;












create or replace NONEDITIONABLE PROCEDURE "Them_Khuyenmai"
                            ( ptenkm IN NVARCHAR2 ,
                            pngaybd IN VARCHAR2  , 
                              pngaykt IN VARCHAR2,
                              pphantramgiam IN FLOAT,
                              ptienmuatoithieu IN FLOAT,
                              ptiengiamtoida IN FLOAT)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  ID VARCHAR2(20);
  
BEGIN

     SELECT  COUNT(*) INTO temp_c1
     FROM khuyenmai;


     SELECT MAX(SUBSTR(RTRIM(makm),3,3)) INTO temp_c2
     FROM khuyenmai;
     
   
    

    IF TO_DATE(pngaybd,'DD/MM/YYYY')>TO_DATE(pngaykt,'DD/MM/YYYY') THEN
        raise_application_error(-20001,'Ngày bắt đầu phải nhỏ hơn ngày kết thúc'); 
    END IF;

	IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;

    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('KM00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('KM0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('KM',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;

   INSERT INTO KHUYENMAI(MAKM,TENKM,NGAYBD,NGAYKT,PHANTRAMGIAM,TIENMUATOITHIEU,TIENGIAMTOIDA)
    VALUES(ID,ptenkm,TO_DATE(pngaybd,'DD/MM/YYYY'),TO_DATE(pngaykt,'DD/MM/YYYY'),pphantramgiam,ptienmuatoithieu,ptiengiamtoida);


END;


BEGIN
   "Them_Khuyenmai"('Sinh nhật shop','12/01/2022','17/01/2022',0.5,500000,500000);  
   "Them_Khuyenmai"('Black Friday','12/11/2022','17/11/2022',0.5,1000000,500000);  
   "Them_Khuyenmai"('Mừng lễ 30/4-1/5','29/04/2022','02/05/2022',0.5,250000,500000);  
--rollback; 
END;


DELETE FROM KHACHHANG;
SELECT * FROM KHACHHANG;
SELECT * FROM sanpham;
SELECT * FROM khuyenmai;
DELETE FROM khuyenmai;







SELECT * FROM CTHOADON
SELECT * FROM HOADON


create or replace NONEDITIONABLE PROCEDURE  Them_HoaDon
                                        ( pmakh IN VARCHAR2,
                                        pdiachigh IN NVARCHAR2)
IS
  temp_c1 float;   
  temp_c2 VARCHAR2(20); 
  temp_c3 DATE; 
  ID VARCHAR2(20);
BEGIN

    SELECT  COUNT(*) INTO temp_c1
    FROM hoadon;

    SELECT MAX(SUBSTR(RTRIM(mahd),3,3))INTO temp_c2
    FROM hoadon;
 
    SELECT CURRENT_DATE INTO temp_c3
    FROM DUAL;   
    
    IF temp_c1 = 0 THEN
		 ID := '0';
	ELSE
         ID := temp_c2;  
    END IF;

    IF ID >= 0 and ID < 9 THEN 
            ID:= CONCAT('HD00',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 9 and ID < 99 THEN 
            ID:= CONCAT('HD0',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    ELSIF ID >= 99 THEN 
            ID:= CONCAT('HD',TO_CHAR(TO_NUMBER(RTRIM(ID))+1));
    END IF;
    
    INSERT INTO HOADON(MAHD,MAKM,NGAYLAPHD,TRANGTHAIHD,THANHTIENHD,GIAMGIA,TONGTIENHD,NGAYTT,TINHTRANGTHANHTOAN,HINHTHUCTT,DIACHIGIAOHANG,NGAYGIAO,TINHTRANGGIAO,MAKH,MANV)
    VALUES (RTRIM(ID),NULL,temp_c3,'chờ xác nhận',0,0,0,temp_c3,'Chưa thanh toán','tiền mặt',pdiachigh,temp_c3,'chưa giao',pmakh,NULL);

END;



BEGIN
    "Them_HoaDon"('KH001','123 sư vạn hạnh');   
    --rollback; 
END;


CREATE OR REPLACE trigger Trg_Insert_TONGTIEHOADON 
		AFTER INSERT  ON CTHOADON
		FOR EACH ROW
		BEGIN
			   UPDATE HOADON 
               SET THANHTIENHD=THANHTIENHD+ :NEW.DONGIABAN*:NEW.SOLUONG
               WHERE :NEW.mahd = HOADON.MAHD;
               
               UPDATE SANPHAM 
               SET SOLUONGTON=SOLUONGTON - :NEW.SOLUONG
               WHERE :NEW.masp = SANPHAM.masp;
        END;
        
CREATE OR REPLACE trigger Trg_Delete_TONGTIEHOADON 
		AFTER DELETE  ON CTHOADON
		FOR EACH ROW
		BEGIN
			   UPDATE HOADON 
               SET THANHTIENHD=THANHTIENHD - :OLD.DONGIABAN*:OLD.SOLUONG 
               WHERE :OLD.mahd = HOADON.MAHD;
               
               UPDATE SANPHAM 
               SET SOLUONGTON=SOLUONGTON + :OLD.SOLUONG
               WHERE :OLD.masp = SANPHAM.masp;
        END;
              
CREATE OR REPLACE trigger Trg_Update_TONGTIEHOADON 
		AFTER UPDATE ON CTHOADON
		FOR EACH ROW
		BEGIN
               UPDATE HOADON 
               SET THANHTIENHD=THANHTIENHD+ :NEW.DONGIABAN*:NEW.SOLUONG
               WHERE :NEW.mahd = HOADON.MAHD;
               
               UPDATE HOADON 
               SET THANHTIENHD=THANHTIENHD - :OLD.DONGIABAN*:OLD.SOLUONG 
               WHERE :OLD.mahd = HOADON.MAHD;
               
               UPDATE SANPHAM 
               SET SOLUONGTON=SOLUONGTON - :NEW.SOLUONG
               WHERE :NEW.masp = SANPHAM.masp;
               
               UPDATE SANPHAM 
               SET SOLUONGTON=SOLUONGTON + :OLD.SOLUONG
               WHERE :OLD.masp = SANPHAM.masp;
        END;
        

SELECT * FROM CTHOADON
SELECT * FROM HOADON
SELECT * FROM SANPHAM


create or replace NONEDITIONABLE PROCEDURE "Them_KM_HoaDon"
                                        ( pmahd IN VARCHAR2,
                                          pmakm IN VARCHAR2)
IS
  temp_phantramgiam float; 
  
  temp_tienmuatoithieu float; 
  temp_tiengiamtoida float; 
  
  temp_ngayKT DATE; 
  temp_ngayBD DATE; 
  
  temp_ngaylaphd DATE; 
  
  temp_thanhtienhd float; 
  
  
BEGIN
    
    SELECT PHANTRAMGIAM
    INTO temp_phantramgiam
    FROM KHUYENMAI
    WHERE MAKM=pmakm;
    
    SELECT NGAYBD
    INTO temp_ngayBD
    FROM KHUYENMAI
    WHERE MAKM=pmakm;
    
    SELECT NGAYKT
    INTO temp_ngayKT
    FROM KHUYENMAI
    WHERE MAKM=pmakm;
    
    SELECT TIENMUATOITHIEU
    INTO temp_tienmuatoithieu
    FROM KHUYENMAI
    WHERE MAKM=pmakm;
    
    SELECT TIENGIAMTOIDA
    INTO temp_tiengiamtoida
    FROM KHUYENMAI
    WHERE MAKM=pmakm;
    
    
    SELECT NGAYLAPHD
    INTO temp_ngaylaphd
    FROM HOADON
    WHERE MAHD=pmahd;
    
    SELECT THANHTIENHD
    INTO temp_thanhtienhd
    FROM HOADON
    WHERE MAHD=pmahd;

    
    IF(temp_ngaylaphd<temp_ngayBD OR temp_ngaylaphd>temp_ngayKT) THEN
        dbms_output.put_line('Mã khuyến mãi đã hết hạn'); 
        UPDATE HOADON
        SET TONGTIENHD=THANHTIENHD,MAKM=NULL
        WHERE MAHD=pmahd;
    ELSIF(temp_thanhtienhd<temp_tienmuatoithieu) THEN
        dbms_output.put_line('Chưa đủ điều kiện để áp dụng khuyến mãi');
        UPDATE HOADON
        SET TONGTIENHD=THANHTIENHD,MAKM=pmakm
        WHERE MAHD=pmahd;
    ELSIF(temp_thanhtienhd>temp_tiengiamtoida) THEN
        UPDATE HOADON
        SET GIAMGIA=temp_tiengiamtoida,TONGTIENHD=THANHTIENHD-temp_tiengiamtoida,MAKM=pmakm
        WHERE MAHD=pmahd;
    ELSE
        UPDATE HOADON
        SET GIAMGIA=THANHTIENHD*temp_phantramgiam,TONGTIENHD=THANHTIENHD-THANHTIENHD*temp_phantramgiam,MAKM=pmakm
        WHERE MAHD=pmahd;
    END IF;
    
END;

SELECt * FROM KHUYENMAI
SELECt * FROM HOADON
SELECt * FROM SANPHAM

INSERT INTO CTHOADON(MAHD,MASP,DONGIABAN,SOLUONG)
        VALUES('HD001','SP001',3000,2);
INSERT INTO CTHOADON(MAHD,MASP,DONGIABAN,SOLUONG)
        VALUES('HD001','SP002',4000,2);
        
        
        
INSERT INTO CTHOADON(MAHD,MASP,DONGIABAN,SOLUONG)
        VALUES('HD002','SP001',3000,2);
INSERT INTO CTHOADON(MAHD,MASP,DONGIABAN,SOLUONG)
        VALUES('HD002','SP002',4000,2);
        
        
BEGIN
   "Them_KM_HoaDon"('HD001','KM007');  
--rollback; 
END;

BEGIN
   "Them_Khuyenmai"('Sinh nhật shop','8/05/2022','12/05/2022',0.5,500,500000);  
--rollback; 
END;


DROP TRIGGER "Trg_Update_TinhTrangHD";
CREATE OR REPLACE trigger Trg_Update_TinhTrangHD
BEFORE UPDATE ON CTHOADON
FOR EACH ROW
DECLARE
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT TRANGTHAIHD
     FROM HOADON
     WHERE HOADON.MAHD=:OLD.MAHD;
    
BEGIN
    open c1;
    fetch c1 into temp_c1;
    close c1;
    
    IF temp_c1 ='Từ chối' THEN
     UPDATE hoadon 
     SET trangthaihd='chờ xác nhận' 
     WHERE HOADON.MAHD = :NEW.MAHD ;
    END IF;
END;



create or replace NONEDITIONABLE PROCEDURE "XacNhan_HoaDon"
                                (pmahd IN VARCHAR2)
AS 
temp_c1 NVARCHAR2(20);

cursor c1 is
     SELECT TRANGTHAIHD
     FROM hoadon
     WHERE mahd=pmahd;
BEGIN

  open c1;
   fetch c1 into temp_c1;
   close c1;
    
    IF temp_c1 ='Đã xác nhận' THEN
     raise_application_error(-20001,'hóa đơn này đã được xác nhận'); 
    END IF;
    
    UPDATE HOADON
    SET TRANGTHAIHD='Đã xác nhận'
    WHERE MAHD=pmahd;
    
    UPDATE CTHOADON
    SET MAHD=pmahd
    WHERE MAHD=pmahd;
END;



create or replace NONEDITIONABLE PROCEDURE "TuChoi_HoaDon"
                                (pmahd IN VARCHAR2)
AS 
temp_c1 NVARCHAR2(20);
temp_c2 NVARCHAR2(20);
BEGIN

    SELECT TINHTRANGTHANHTOAN
    INTO temp_c1
    FROM HOADON
    WHERE MAHD=pmahd;
    
    SELECT TINHTRANGGIAO
    INTO temp_c2
    FROM HOADON
    WHERE MAHD=pmahd;
    
    IF(temp_c1='Chưa thanh toán' AND temp_c2='chưa giao' ) THEN
        UPDATE HOADON
        SET TRANGTHAIHD='Từ chối'
        WHERE MAHD=pmahd;
        
        UPDATE CTHOADON
        SET MAHD=pmahd
        WHERE MAHD=pmahd;
    ELSE 
        raise_application_error(-20001,'KHÔNG THỂ TỪ CHỐI'); 
    END IF;
END;



SELECT * FROM CTHOADON
DROP TRIGGER "Trg_Update_SOLUONGTON_HOADON";
CREATE OR REPLACE trigger Trg_Update_SOLUONGTON_HOADON
BEFORE UPDATE OF MAHD ON CTHOADON
FOR EACH ROW
DECLARE
temp_c1 NVARCHAR2(20);
temp_c2 NVARCHAR2(20);
    
BEGIN
     SELECT TRANGTHAIHD
     INTO temp_c1 
     FROM hoadon
     WHERE mahd=:NEW.MAHD;
     
     SELECT TRANGTHAIHD
     INTO temp_c2 
     FROM hoadon
     WHERE mahd=:OLD.MAHD;
    
    IF temp_c1='Từ chối' THEN
         UPDATE sanpham 
         SET SOLUONGTON=SOLUONGTON+:NEW.SOLUONG
         WHERE SANPHAM.MASP = :NEW.MASP ;
    ELSIF temp_c1='Đã xác nhận' AND temp_c2='Từ chối' THEN
         UPDATE sanpham 
         SET SOLUONGTON=SOLUONGTON-:NEW.SOLUONG
         WHERE SANPHAM.MASP = :NEW.MASP ;
    END IF;
END;

SELECT * FROM HOADON
SELECT * FROM CTHOADON
SELECT * FROM SANPHAM

BEGIN
    "XacNhan_HoaDon"('HD001');
END;

BEGIN
    "TuChoi_HoaDon"('HD001');
END;

