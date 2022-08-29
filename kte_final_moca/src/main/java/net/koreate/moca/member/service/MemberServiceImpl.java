package net.koreate.moca.member.service;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import net.koreate.moca.member.dao.MemberDAO;
import net.koreate.moca.member.vo.MemberVO;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

	private final MemberDAO dao;

	@Override
	public MemberVO logIn(MemberVO vo) throws Exception {
		return dao.logIn(vo);
	}

	@Override
	public void signUp(MemberVO vo) throws Exception {
		dao.signUp(vo);
	}

	@Override
	public void memberUpdate(MemberVO vo) throws Exception {
		dao.memberUpdate(vo);
	}

	@Override

	public MemberVO searchId(MemberVO vo) throws Exception {
		return dao.searchId(vo.getId());
	}

	@Override
	public MemberVO pwCheck(MemberVO vo) throws Exception {
		return dao.pwCheck(vo.getPw());
	}

	@Override

	public void delete(MemberVO vo) throws Exception{
		dao.delete(vo.getNo());
	}

	@Override
	public List<MemberVO> findByKeyword(String keyword) {
		return dao.findByKeyword(keyword);

	}

}
