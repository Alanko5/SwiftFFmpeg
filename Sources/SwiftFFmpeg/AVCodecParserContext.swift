//
//  AVCodecParserContext.swift
//  SwiftFFmpeg
//
//  Created by sunlubo on 2018/7/1.
//

import CFFmpeg

typealias CAVCodecParserContext = CFFmpeg.AVCodecParserContext

public final class AVCodecParserContext {
    private let codecCtx: AVCodecContext

    let cContextPtr: UnsafeMutablePointer<CAVCodecParserContext>
    var cContext: CAVCodecParserContext { return cContextPtr.pointee }

    public init(codecCtx: AVCodecContext) {
        self.codecCtx = codecCtx
        self.cContextPtr = av_parser_init(Int32(codecCtx.codec.id.rawValue))
    }

    /// Parse a packet.
    ///
    /// - Parameters:
    ///   - data: input buffer.
    ///   - size: buffer size in bytes without the padding.
    ///     I.e. the full buffer size is assumed to be `buf_size + AV_INPUT_BUFFER_PADDING_SIZE`.
    ///     To signal EOF, this should be 0 (so that the last frame can be output).
    ///   - packet: packet
    ///   - pts: input presentation timestamp.
    ///   - dts: input decoding timestamp.
    ///   - pos: input byte position in stream.
    /// - Returns: The number of bytes of the input bitstream used.
    public func parse(
        data: UnsafePointer<UInt8>,
        size: Int,
        packet: AVPacket,
        pts: Int64 = .noPTS,
        dts: Int64 = .noPTS,
        pos: Int64 = 0
    ) -> Int {
        var poutbuf: UnsafeMutablePointer<UInt8>?
        var poutbufSize: Int32 = 0
        let ret = av_parser_parse2(cContextPtr, codecCtx.cContextPtr, &poutbuf, &poutbufSize, data, Int32(size), pts, dts, pos)
        packet.cPacketPtr.pointee.data = poutbuf
        packet.cPacketPtr.pointee.size = poutbufSize
        return Int(ret)
    }

    deinit {
        av_parser_close(cContextPtr)
    }
}
