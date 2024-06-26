//
//  DrawingView.swift
//  PADO
//
//  Created by 김명현 on 2/8/24.
//

import CoreGraphics
import PhotosUI
import SwiftUI

struct DrawingView: View {
    @ObservedObject var padorideVM: PadoRideViewModel
    
    var body: some View {
        ZStack {
            Color.main.ignoresSafeArea()
            GeometryReader { proxy -> AnyView in
                
                let size = proxy.frame(in: .global)
                
                DispatchQueue.main.async {
                    if padorideVM.rect == .zero {
                        padorideVM.rect = size
                    }
                }
                
                return AnyView(
                    ZStack {
                        CanvasView(padorideVM: padorideVM,
                                   canvas: $padorideVM.canvas,
                                   toolPicker: $padorideVM.toolPicker,
                                   rect: size.size)
                        
                        ForEach(padorideVM.textBoxes) { box in
                            Text(padorideVM.textBoxes[padorideVM.currentTextIndex].id == box.id && padorideVM.addNewBox ? "" : box.text)
                                .font(.system(size: 70))
                                .fontWeight(box.isBold ? .bold : .none)
                                .foregroundColor(box.textColor)
                                .offset(box.offset)
                                .rotationEffect(box.rotation)
                                .scaleEffect(box.scale)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            // 드래그 시작 시점의 offset 임시 저장
                                            padorideVM.handleTextBoxDragGesture(value: value, box: box)
                                        })
                                        .onEnded({ value in
                                            // 드래그가 끝났을 때 lastOffset 업데이트
                                            padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].lastOffset = padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].offset
                                        })
                                        .simultaneously(with:
                                                            MagnificationGesture()
                                            .onChanged({ value in
                                                padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].scale = box.lastScale * value
                                            })
                                                .onEnded({ value in
                                                    padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].lastScale = padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].scale
                                                })
                                                    .simultaneously(with:
                                                                        RotationGesture()
                                                        .onChanged({ value in
                                                            padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].rotation = box.lastRotation + value
                                                        })
                                                            .onEnded({ value in
                                                                padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].lastRotation = padorideVM.textBoxes[padorideVM.getTextIndex(textBox: box)].rotation
                                                            })
                                                                   )
                                                        .simultaneously(with:
                                                                            LongPressGesture(minimumDuration: 1.0)
                                                            .onEnded { _ in
                                                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                                                generator.impactOccurred()
                                                                padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                                                                padorideVM.canvas.resignFirstResponder()
                                                                padorideVM.currentTextIndex = padorideVM.getTextIndex(textBox: box)
                                                                withAnimation{
                                                                    padorideVM.modifyBox = true
                                                                }
                                                            })
                                                       )
                                )
                        }
                        
                        ForEach(padorideVM.imageBoxes) { box in
                            box.image
                                .resizable()
                                .frame(width: box.size.width, height: box.size.height)
                                .offset(box.offset)
                                .rotationEffect(box.rotation)
                                .scaleEffect(box.scale)
                                .gesture(
                                    DragGesture()
                                        .onChanged({ value in
                                            // 드래그 시작 시점의 offset 임시 저장
                                            padorideVM.handleImageBoxDragGesture(value: value, box: box)
                                        })
                                        .onEnded({ value in
                                            // 드래그가 끝났을 때 lastOffset 업데이트
                                            padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].lastOffset = padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].offset
                                        })
                                        .simultaneously(with:
                                                            MagnificationGesture()
                                            .onChanged({ value in
                                                padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].scale = box.lastScale * value
                                            })
                                                .onEnded({ value in
                                                    padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].lastScale = padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].scale
                                                })
                                                    .simultaneously(with:
                                                                        RotationGesture()
                                                        .onChanged({ value in
                                                            padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].rotation = box.lastRotation + value
                                                        })
                                                            .onEnded({ value in
                                                                padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].lastRotation = padorideVM.imageBoxes[padorideVM.getImageIndex(imageBox: box)].rotation
                                                            })
                                                                   )
                                                        .simultaneously(with:
                                                                            LongPressGesture(minimumDuration: 1.0)
                                                            .onEnded { _ in
                                                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                                                generator.impactOccurred()
                                                                padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                                                                padorideVM.canvas.resignFirstResponder()
                                                                padorideVM.currentImageIndex = padorideVM.getImageIndex(imageBox: box)
                                                                Task {
                                                                    await padorideVM.deleteImage()
                                                                }
                                                            })
                                                       )
                                )
                        }
                    }
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                // 그리기 버튼
                Button {
                    if padorideVM.toolPicker.isVisible {
                        padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                        padorideVM.canvas.resignFirstResponder()
                    } else {
                        Task {
                            padorideVM.toolPicker.setVisible(true, forFirstResponder: padorideVM.canvas)
                            padorideVM.canvas.becomeFirstResponder()
                        }
                    }
                } label: {
                    Image(systemName: "scribble")
                        .foregroundStyle(.white)
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                // 사진앨범 버튼
                PhotosPicker(selection: $padorideVM.pickerImageItem,
                             matching: .images) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 25, height: 20)
                }
                             .onChange(of: padorideVM.pickerImageItem) { _, _ in
                                 Task {
                                     await padorideVM.loadImageFromPickerItem(padorideVM.pickerImageItem)
                                 }
                             }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                // 텍스트 박스
                Button {
                    padorideVM.textBoxes.append(TextBox())
                    
                    padorideVM.currentTextIndex = padorideVM.textBoxes.count - 1
                    
                    withAnimation{
                        padorideVM.addNewBox.toggle()
                    }
                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                    padorideVM.canvas.resignFirstResponder()
                } label: {
                    Image(systemName: "t.square")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    padorideVM.showingModal = true
                    padorideVM.saveImage()
                    padorideVM.toolPicker.setVisible(false, forFirstResponder: padorideVM.canvas)
                    padorideVM.pickerImageItem = nil
                } label: {
                    Text("다음")
                        .foregroundStyle(.white)
                        .font(.system(size:16, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $padorideVM.showingModal) {
            SendPadoView(padorideVM: padorideVM)
                .presentationDetents([.fraction(0.2)])
                .presentationDragIndicator(.visible)
        }
    }
}
