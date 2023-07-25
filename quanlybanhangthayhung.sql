-- 1. Liệt kê thông tin về nhân viên trong cửa hàng, gồm: mã nhân viên, họ tên
-- nhân viên, giới tính, ngày sinh, địa chỉ, số điện thoại, tuổi. Kết quả sắp xếp
-- theo tuổi.
select manv,hoten,ngaysinh,diachi,dienthoai,year(now()) - year(ngaysinh) age from nhanvien order by age;

-- 2. Liệt kê các hóa đơn nhập hàng trong tháng 6/2018, gồm thông tin số phiếu
-- nhập, mã nhân viên nhập hàng, họ tên nhân viên, họ tên nhà cung cấp, ngày
-- nhập hàng, ghi chú.
select pn.sopn,nv.manv,nv.hoten,ncc.tenncc,pn.ngaynhap,pn.ghichu from phieunhap pn 
join ctphieunhap ctpn on pn.sopn = ctpn.sopns
join nhanvien nv on pn.manvs = nv.manv
join nhacungcap ncc on pn.manccs = ncc.mancc
where month(pn.ngaynhap) = 6 and year(pn.ngaynhap) = 2018; 

-- 3. Liệt kê tất cả sản phẩm có đơn vị tính là chai, gồm tất cả thông tin về sản
-- phẩm.
select * from sanpham where donvitinh like "chai";

-- 4. Liệt kê chi tiết nhập hàng trong tháng hiện hành gồm thông tin: số phiếu
-- nhập, mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính, số lượng, giá
-- nhập, thành tiền.
select pn.sopn,sp.masp,sp.tensp,lsp.tenlsp,sp.donvitinh,ctpn.soluong,ctpn.gianhap,(ctpn.soluong * ctpn.gianhap) total from phieunhap pn 
join ctphieunhap ctpn on ctpn.sopns = pn.sopn
join sanpham sp on ctpn.masps = sp.masp
join loaisp lsp on lsp.malsp = sp.mlsp
where month(pn.ngaynhap) = month(now());

-- 5. Liệt kê các nhà cung cấp có giao dịch mua bán trong tháng hiện hành, gồm
-- thông tin: mã nhà cung cấp, họ tên nhà cung cấp, địa chỉ, số điện thoại,
-- email, số phiếu nhập, ngày nhập. Sắp xếp thứ tự theo ngày nhập hàng.
select mancc,tenncc,diachi,dt,email,sopn,ngaynhap from phieunhap pn 
join nhacungcap ncc on pn.manccs = ncc.mancc
where month(pn.ngaynhap) = month(now())
order by pn.ngaynhap;

-- 6. Liệt kê chi tiết hóa đơn bán hàng trong 6 tháng đầu năm 2018 gồm thông tin:
-- số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm,
-- đơn vị tính, số lượng, giá bán, doanh thu.
select px.sopx,nv.hoten,px.ngayban,sp.masp,sp.tensp,sp.donvitinh,ctpx.sl,ctpx.giaban,(ctpx.sl * ctpx.giaban) total from phieuxuat px
join nhanvien nv on px.manvs = nv.manv
join ctphieuxuat ctpx on ctpx.spx = px.sopx
join sanpham sp on sp.masp = ctpx.msp
where (month(px.ngayban) between 1 and 6) and year(px.ngayban) = 2018;

-- 7. Hãy in danh sách khách hàng có ngày sinh nhật trong tháng hiện hành (gồm
-- tất cả thông tin của khách hàng)
select * from khachhang where month(ngaysinh) = month(now());

-- 8. Liệt kê các hóa đơn bán hàng từ ngày 15/04/2018 đến 15/05/2018 gồm các
-- thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên
-- sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu.
select px.sopx,nv.hoten,px.ngayban,sp.masp,sp.tensp,sp.donvitinh,ctpx.sl,ctpx.giaban,(ctpx.sl * ctpx.giaban) total from phieuxuat px
join nhanvien nv on px.manvs = nv.manv
join ctphieuxuat ctpx on ctpx.spx = px.sopx
join sanpham sp on sp.masp = ctpx.msp
where day(px.ngayban) = 15 and (month(px.ngayban) between 4 and 5) and year(px.ngayban) = 2018;

-- 9. Liệt kê các hóa đơn mua hàng theo từng khách hàng, gồm các thông tin: số
-- phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá.
select kh.makh,kh.tenkh,sum(ctpx.sl * ctpx.giaban) from phieuxuat px 
join khachhang kh on px.makhs = kh.makh
join ctphieuxuat ctpx on ctpx.spx = px.sopx
group by kh.makh;

-- 10. Cho biết tổng số chai nước xả vải Comfort đã bán trong 6 tháng đầu năm 
-- 2018. Thông tin hiển thị: tổng số lượng.
select sp.tensp,sum(ctpx.sl) from sanpham sp 
join ctphieuxuat ctpx on sp.masp = ctpx.msp
join phieuxuat px on ctpx.spx = px.sopx
where (month(px.ngayban) between 1 and 6) and year(px.ngayban) = 2018 and sp.tensp like "nước xả vải Comfort" 
group by sp.masp;

-- 11.Tổng kết doanh thu theo từng khách hàng theo tháng, gồm các thông tin:
-- tháng, mã khách hàng, tên khách hàng, địa chỉ, tổng tiền.
select month(px.ngayban),kh.makh,kh.tenkh,kh.diachi,sum(ctpx.sl * ctpx.giaban) from phieuxuat px 
join khachhang kh on px.makhs = kh.makh
join ctphieuxuat ctpx on ctpx.spx = px.sopx
group by kh.makh,month(px.ngayban);

-- 12.Thống kê tổng số lượng sản phẩm đã bán theo từng tháng trong năm, gồm
-- thông tin: năm, tháng, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số
-- lượng.
select month(px.ngayban),year(px.ngayban),sp.masp,sp.tensp,sp.donvitinh,sum(ctpx.sl) from phieuxuat px 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
join sanpham sp on ctpx.msp = sp.masp
group by sp.masp,month(px.ngayban),year(px.ngayban);

-- 13.Thống kê doanh thu bán hàng trong trong 6 tháng đầu năm 2018, thông tin
-- hiển thị gồm: tháng, doanh thu.
select sum(total) from (select sum(ctpx.sl * ctpx.giaban) total from phieuxuat px
join ctphieuxuat ctpx on px.sopx = ctpx.spx 
where (month(px.ngayban) between 1 and 6) and year(px.ngayban) = 2023
group by px.sopx) as a; 

-- 14.Liệt kê các hóa đơn bán hàng của tháng 5 và tháng 6 năm 2018, gồm các
-- thông tin: số phiếu, ngày bán, họ tên nhân viên bán hàng, họ tên khách hàng,
-- tổng trị giá.
select px.sopx,px.ngayban,nv.hoten,kh.tenkh,sum(ctpx.sl * ctpx.giaban) from phieuxuat px
join ctphieuxuat ctpx on px.sopx = ctpx.spx
join nhanvien nv on px.manvs = nv.manv
join khachhang kh on kh.makh = px.makhs
where (month(px.ngayban) = 5 or month(px.ngayban) = 6) and year(px.ngayban) = 2018
group by px.sopx;

-- 15.Cuối ngày, nhân viên tổng kết các hóa đơn bán hàng trong ngày, thông tin
-- gồm: số phiếu xuất, mã khách hàng, tên khách hàng, họ tên nhân viên bán
-- hàng, ngày bán, trị giá.
select px.sopx,px.ngayban,nv.hoten,kh.tenkh,sum(ctpx.sl * ctpx.giaban) total from phieuxuat px
join ctphieuxuat ctpx on px.sopx = ctpx.spx
join nhanvien nv on px.manvs = nv.manv
join khachhang kh on kh.makh = px.makhs
where day(px.ngayban) = day(now()) 
group by px.sopx;

-- 16.Thống kê doanh số bán hàng theo từng nhân viên, gồm thông tin: mã nhân
-- viên, họ tên nhân viên, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số
-- lượng.
select nv.manv,px.sopx,sum(ctpx.sl) from nhanvien nv 
join phieuxuat px on nv.manv = px.manvs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
join sanpham sp on sp.masp = ctpx.msp
group by px.sopx;

-- 17.Liệt kê các hóa đơn bán hàng cho khách vãng lai (KH01) trong quý 2/2018,
-- thông tin gồm số phiếu xuất, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị
-- tính, số lượng, đơn giá, thành tiền.
select px.sopx,px.ngayban,sum(ctpx.sl * ctpx.giaban) from phieuxuat px 
join khachhang kh on px.makhs = kh.makh
join ctphieuxuat ctpx on ctpx.spx = px.sopx
join sanpham sp on sp.masp = ctpx.msp
where kh.makh like "KH01" and (month(px.ngayban) between 3 and 6) and year(px.ngayban) = 2023
group by px.sopx;

-- 18.Liệt kê các sản phẩm chưa bán được trong 6 tháng đầu năm 2018, thông tin
-- gồm: mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính.
select ctpx.spx from ctphieuxuat ctpx 
join phieuxuat px on px.sopx = ctpx.spx 
where date(px.ngayban) between '2023/01/01' and '2023/06/30';

select * from sanpham where masp not in (select ctpx.spx from ctphieuxuat ctpx 
join phieuxuat px on px.sopx = ctpx.spx 
where date(px.ngayban) between '2023/01/01' and '2023/06/30');

-- 19.Liệt kê danh sách nhà cung cấp không giao dịch mua bán với cửa hàng trong
-- quý 2/2018, gồm thông tin: mã nhà cung cấp, tên nhà cung cấp, địa chỉ, sốN
-- điện thoại.
select ncc.mancc,ncc.tenncc,ncc.diachi,ncc.dt from nhacungcap ncc 
join phieunhap pn on ncc.mancc = pn.manccs
where not ncc.mancc = pn.manccs;

-- 20.Cho biết khách hàng có tổng trị giá đơn hàng lớn nhất trong 6 tháng đầu năm
-- 2018.
-- tính tổng tiền thoe ma khach hang
select kh.makh,sum(ctpx.giaban * ctpx.sl) total from khachhang kh 
join phieuxuat px on kh.makh = px.makhs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
group by kh.makh;
-- tim tong tiền có hóa đơn lớn nhất
select makh,total from (select kh.makh makh,sum(ctpx.giaban * ctpx.sl) total from khachhang kh 
join phieuxuat px on kh.makh = px.makhs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
where (month(px.ngayban) between 1 and 6) and year(px.ngayban) = 2018
group by kh.makh) as a where total = (select max(total) from (select kh.makh makh,sum(ctpx.giaban * ctpx.sl) total from khachhang kh 
join phieuxuat px on kh.makh = px.makhs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
group by kh.makh) as b);
-- tìm thông tin khach hang co hoa don lon nhat
select * from khachhang where makh = (select makh from (select kh.makh makh,sum(ctpx.giaban * ctpx.sl) total from khachhang kh 
join phieuxuat px on kh.makh = px.makhs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
where (month(px.ngayban) between 1 and 6) and year(px.ngayban) = 2018
group by kh.makh) as a where total = (select max(total) from (select kh.makh makh,sum(ctpx.giaban * ctpx.sl) total from khachhang kh 
join phieuxuat px on kh.makh = px.makhs 
join ctphieuxuat ctpx on px.sopx = ctpx.spx
group by kh.makh) as b));

-- 21.Cho biết mã khách hàng và số lượng đơn đặt hàng của mỗi khách hàng.
select kh.makh,count(px.sopx) from phieuxuat px 
join khachhang kh on px.makhs = kh.makh 
group by kh.makh;

-- 22.Cho biết mã nhân viên, tên nhân viên, tên khách hàng kể cả những nhân viên
-- không đại diện bán hàng.
select nv.manv,nv.hoten,kh.tenkh from phieuxuat px 
join nhanvien nv on px.manvs = nv.manv
join khachhang kh on px.makhs = kh.makh
where (px.manvs = nv.manv or not px.manvs = nv.manv) and px.makhs = kh.makh;

-- 23.Cho biết số lượng nhân viên nam, số lượng nhân viên nữ
-- không phân biệt giới tính

-- 24.Cho biết mã nhân viên, tên nhân viên, số năm làm việc của những nhân viên
-- có thâm niên cao nhất.
select *,(year(now()) - year(ngaybilua)) 'thâm niên' from nhanvien 
where (year(now()) - year(ngaybilua)) = (select max(year(now()) - year(ngaybilua)) from nhanvien);

-- 25.Hãy cho biết họ tên của những nhân viên đã đến tuổi về hưu (nam:60 tuổi,
-- nữ: 55 tuổi)
-- không có field gới tính

-- 26.Hãy cho biết họ tên của nhân viên và năm về hưu của họ.
select *,(year(ngaysinh) + 60) 'năm về hưu' from nhanvien;

-- 27.Cho biết tiền thưởng tết dương lịch của từng nhân viên. Biết rằng - thâm
-- niên <1 năm thưởng 200.000 - 1 năm <= thâm niên < 3 năm thưởng
-- 400.000 - 3 năm <= thâm niên < 5 năm thưởng 600.000 - 5 năm <= thâm
-- niên < 10 năm thưởng 800.000 - thâm niên >= 10 năm thưởng 1.000.000
select hoten,(year(now()) - year(ngaybilua)) seniority,
case 
	when (year(now()) - year(ngaybilua)) < 1 then '200.000'
    when (year(now()) - year(ngaybilua)) >= 1 and (year(now()) - year(ngaybilua)) < 3 then '400.000'
    when (year(now()) - year(ngaybilua)) >= 3 and (year(now()) - year(ngaybilua)) < 5 then '600.000'
    when (year(now()) - year(ngaybilua)) >= 5 and (year(now()) - year(ngaybilua)) < 10 then '800.000'
	ELSE '1.000.000'
end 'lương thưởng'
from nhanvien;

-- 28.Cho biết những sản phẩm thuộc ngành hàng Hóa mỹ phẩm
-- không có loại ngành hóa mỹ phẩm

-- 29.Cho biết những sản phẩm thuộc loại Quần áo.
-- không có sản phẩm thuộc loại quần áo

-- 30.Cho biết số lượng sản phẩm loại Quần áo.
-- không có sản phẩm thuộc loại quần áo

-- 31.Cho biết số lượng loại sản phẩm ngành hàng Hóa mỹ phẩm.
-- không có sản phẩm thuộc loại hóa mỹ phẩm

-- 32.Cho biết số lượng sản phẩm theo từng loại sản phẩm.
select lsp.tenlsp,sum(ctpn.soluong - ctpx.sl) from sanpham sp 
join ctphieunhap ctpn on sp.masp = ctpn.masps
join ctphieuxuat ctpx on sp.masp = ctpx.msp
join loaisp lsp on lsp.malsp = sp.mlsp
group by lsp.malsp;
